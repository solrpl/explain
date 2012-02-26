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
module SolrExplanation
  module Element
    class TreeElement
      attr_accessor :available_children


      def build(metadata, lines)
        $Log.debug("#{self.class}.build() with #{lines.length} lines")

        while (lines.length > 0)
          child = lines.shift
          next if child == '), product of:' #FIXME: this is error in 4.0-snapshot code
          #old api
          matches = available_children.find_all{|x| x.matches?(child) }

          #new api
          #TODO remove old API
          obj_matches = available_children.map{|x| x.try_create(metadata, child)}.find_all{|x| x}
          if( matches.length + obj_matches.length) != 1
            if matches.length + obj_matches.length > 1
              raise "#{self.class} Ambiguity: multiple plugins: #{matches.join(',')}, #{obj_matches.join(',')} for line: #{child}"
            else
              raise "#{self.class} No plugin for line: '#{child}' and version '#{metadata.version}'"
            end
          end
          if (matches.length == 1)
            new_item = matches[0].new(child, true) #TODO: remove 'use_pre' - deprecated feature
          else
            new_item = obj_matches[0]
          end
          self << new_item
          child_lines = lines.take_while{|x| TreeElement.level_for(x) > new_item.level || x == '), product of:'} #FIXME: this is error in 4.0-snapshot code
          lines.shift(child_lines.length)
          new_item.build(metadata, child_lines)
        end
      end

      def self.level_for(line)
        line[/^\s*/].length
      end

      def self.try_create(line)
      end

      def self.matches?(line)
      end
    end
  end
end
