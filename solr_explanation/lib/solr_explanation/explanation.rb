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
require 'solr_explanation/elements/tree_element'
require 'set'

module SolrExplanation
  class Explanation < Element::TreeElement
    attr_reader :level, :line, :score, :value, :attributes, :capabilities, :impact

    # Create new explanation item. 
    #   line - line of explain to parse
    #   use_pre - call "parse_details_pre" after creation. This is deprecated feature.
    def initialize(line, use_pre = false)
      @level = Explanation::level_for(line)
      @impact = 0
      @line = line.gsub(/^\s*/, '')
      if @line =~ Regexp.new("^(#{Explanation.score_regexp}) = (.*)\\s*")
        @score = $1.to_f
        @value = $2
      else
        raise "Cannot determine score: #{line}"
      end
      @children = []
      @attributes = {}
      @capabilities = Set.new
      @available_children = []
      parse_details_pre
    end

    def <<(child)
      @children << child
    end

    def attribute(a)
      @attributes[a]
    end

    def children(cap = nil)
      if cap
        @children.find_all{|x| x.capabilities.include? cap}
      else
        @children
      end
    end

    def items_with(cap)
      res = []
      if(@capabilities.include? cap)
        res << self
      end
      @children.each do |child|
        res += child.items_with(cap)
      end
      res
    end

    def short_description
      if @attributes[:short_description]
        @attributes[:short_description]
      elsif @attributes[:query]
        @attributes[:query]
      else
        @value
      end
    end

    def add_attribute(key, val)
      @attributes[key] = val
    end

    def add_capability(cap)
      @capabilities << cap
    end

    def self.when_match(line, re)
      if line =~ Explanation.regexp(re)
        ret = self.new(line)
        yield(ret, $~) if block_given?
        return ret
      end
    end

    def self.when_match_for_version(meta, ver, line, re, &block)
      if meta.compatible_with ver 
        obj = self.when_match(line, re, &block)
        if obj && ver != 'auto'
          meta.version = ver
        end
        return obj
      end
    end

    def self.regexp(re)
      Regexp.new('^\s*' + Explanation.score_regexp.to_s + ' = ' + re.to_s + '\s*$')
    end

    def self.score_regexp
      /-?(?:[0-9]+(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?)|(?:NaN)|(?:-?Infinity)/
    end

    def debug(cap = nil)
      puts "#{' ' * @level}#{@line}"
      children(cap).each do |child|
        child.debug(cap)
      end
    end

    def post_process
      @children.each do |child|
        child.post_process
      end
      parse_details_post
    end

    def parse_details_pre
    end

    def parse_details_post
    end

    def impact=(imp)
      @impact = imp
      add_capability(:has_impact)
      set_impact_for_children(imp)
    end

    def set_impact_for_children(imp)
      raise "set_impact_for_children not defined for: #{self.class}"
    end

  end
end
