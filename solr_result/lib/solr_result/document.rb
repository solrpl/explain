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
require 'active_support/ordered_hash'

module SolrResult
  class Document
    attr_accessor :explanation, :type
    attr_reader :key

    def initialize(params)
      @type = :found
      if params.length > 0
        @fields = construct(params.keys.sort{|x,y| x.to_s <=> y.to_s}, params)
      else
        @fields = ActiveSupport::OrderedHash.new
      end
      @key = nil
    end

    def [](name)
      @fields[name]
    end  

    def fields
      @fields
    end

    def field_names
      @fields.keys
    end

    def uniq_id
      if @key
        @fields[@key]
      else
        nil
      end
    end

    def key=(k)
      # convert hash - first should be key
      if @fields.length > 0
        @fields = construct([k] + (@fields.keys - [k]), @fields)
      end
      @key = k
    end

    private
      
      def construct(tab, hash)
        out = ActiveSupport::OrderedHash.new
        tab.each do |item|
          out[item] = hash[item]
        end
        pp out
        out
      end

  end
end
