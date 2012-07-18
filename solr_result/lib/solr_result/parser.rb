#
#   Copyright [2011-2012] [Solr.pl, Marek Rogoziński, Rafał Kuć]
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
require 'solr_result/output'
require 'solr_result/document'
require 'solr_result/params'
require 'solr_result/debug'
require 'solr_result/info'
require 'solr_result/version_resolver'
require 'rubygems'
require 'rexml/document'
require 'date'
require 'pp' #TODO usunąć
require 'active_support/ordered_hash'

class String
  def to_date
    DateTime.parse self
  end

  def to_bool
    "true" == self
  end
end


module SolrResult
  class Parser
    def self.parser
      Parser.new
    end

    def parse(content)
      o = Output.new
      info = []
      docs = []
      explain_other_docs = []
      params = {}
      debug = Debug.new({})
      found = 0
      grouped = false

      begin
        doc = REXML::Document.new(content)
        version = VersionResolver.resolve(doc)
        debug = parse_debug(doc, info)
        docs = parse_docs(doc, version, debug.explain, info)
        explain_other_docs = parse_explain_other_docs(doc, version, debug.explainOther, info)
        params = parse_params(doc)
        grouped = is_grouped_result(doc, info)
        found = get_num_found(doc, grouped, info)
      rescue REXML::ParseException => e
          pp e
          info << Info.new(:error, 'solr.result.info.parse.error')
      end


      o.attributes(
        :docs => merge_docs(docs,explain_other_docs),
        :found => found,
        :params => params,
        :debug => debug,
        :info => info,
        :parsed => info.find{|x| x.status == :error} == nil
      )
      o
    end

    private
      def parse_docs(doc, version, explain, info)
        docs = []
        doc.elements.each("//doc") do |item|
          params = {}
          item.elements.each do |field|
            params.merge! merge_item(field)
          end
          docs <<  SolrResult::Document.new(params)
        end
        if docs.length == 0
          return docs
        end
        key = find_key(docs, explain.keys)
        if key
          docs.each do |doc| 
            doc.key = key.to_sym
            sym = doc.uniq_id.to_sym
            doc.explanation = parse_explaination(doc.uniq_id, version, explain[sym])
            explain.delete sym
          end
          if explain.length > 0
            raise "TODO: some explain not attached. Size: #{explain.length}"
          end
        else
          info << Info.new(:warning, 'solr.result.info.parse.unique')
          explain.keys.each_with_index do |exp_key, idx|
            docs[idx].explanation = parse_explaination(exp_key, version, explain[exp_key])
          end
        end
        docs
      end

      def parse_debug(doc, info)
        params = merge_container_to(doc, "/response/lst[@name='debug']/*")
        unless params.length > 0
          info << Info.new(:warning, 'solr.result.info.parse.debug')
          params = Hash.new({})
        end
        Debug.new(params)
      end

      def parse_explain_other_docs(doc, version, others, info)
        docs = []
        unless others
          info << Info.new(:info, 'solr.result.info.parse.debugOther')
          return docs
        end
        others.each do |key, val|
          explanation = parse_explaination(key, version, val)
          doc = Document.new({:id => key.to_s})
          doc.type = :other
          doc.explanation = explanation
          doc.key = :id
          docs << doc
        end
        docs
      end

      def parse_explaination(id, version, content)
        metadata = SolrExplanation::Metadata.new(:id => id, :version => version)
        parser = SolrExplanation::Parser.parser(metadata)
        parser.parse(content)
      end

      def parse_params(doc)
        Params.new(merge_container_to(doc, "/response/lst[@name='responseHeader']/lst[@name='params']/*"))
      end

      # Find the name of unique identifier
      def find_key(docs, expl)
        found = []
        expl.each do |id|     # for each explainId
          f = []
          docs.each do |doc|  # for each document
            doc.fields.each_pair do |name, field| # for each field in document
              if field == id.to_s
                f << name
              end
            end
            found << f
          end
        end
        # we have candidates for key for every document. Now it's time to seek for intersection
        cmp = found.shift
        found.each do |f|
          cmp = cmp & f
        end
        if cmp && cmp.length == 1
          return cmp[0]
        else
          return nil
        end
      end

      def get_num_found(doc, grouped, info)
        if grouped 
            o = REXML::XPath.first(doc, "/response/lst[@name='grouped']")
            if o
              REXML::XPath.first(doc, "/response/lst[@name='grouped']/lst/int").attributes['matches'].to_i
            else
              info << Info.new(:error, 'solr.result.info.parse.numFound')
              0
            end
        else        
            o = REXML::XPath.first(doc, "/response/result")
            if o
              REXML::XPath.first(doc, "/response/result").attributes['numFound'].to_i
            else
              info << Info.new(:error, 'solr.result.info.parse.numFound')
              0
            end
        end
      end
      
      def is_grouped_result(doc, info)
        o = REXML::XPath.first(doc, "/response/lst[@name='grouped']")
        if o
          true
        else
          false
        end
      end

      def merge_docs(docs, explain_docs)
        to_docs = []
        explain_docs.each do |doc|
          item = docs.find{|d| d.uniq_id == doc.uniq_id}
          if item
            item.type = :found_and_other
          else
            to_docs << doc
          end
        end

        docs + to_docs
      end

    protected

      def merge_container_to(doc, path)
        output = ActiveSupport::OrderedHash.new

        doc.elements.each(path) do |item|
          output.merge! merge_item(item)
        end
        output
      end

      def merge_item(item)
        output = ActiveSupport::OrderedHash.new
        types = { "str" => :to_s, "int" => :to_i, "long" => :to_i, "double" => :to_f, "float" => :to_f, "null" => :to_s, "date" => :to_date, "bool" => :to_bool }

        if types.keys.member? item.name
          if item.attributes['name']
            output[item.attributes['name'].to_sym] = item.text.send(types[item.name])
            return output
          else
            return item.text.send(types[item.name])
          end
        end
        if 'arr' == item.name
          name = item.attributes['name'].to_sym
          output[name] = []
          item.elements.each do |ch|
            output[name] << merge_item(ch)
          end
          return output
        end
        if 'lst' == item.name
          name = item.attributes['name'].to_sym
          output[name] = {}
          item.elements.each do |ch|
            output[name].merge! merge_item(ch)
          end
          return output
        end
        raise "Unknown type: <#{item.name}> (#{item})"
      end
  end
end
