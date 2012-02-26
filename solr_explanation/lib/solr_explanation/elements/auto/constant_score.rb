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
require 'solr_explanation/explanation'
require 'solr_explanation/elements/auto/boost'
require 'solr_explanation/elements/auto/query_norm'

module SolrExplanation
  module Element
    module Auto
      class ConstantScore < Explanation

        def self.try_create(metadata, line)
          when_match_for_version(metadata, 'auto',line, /\(MATCH\) ConstantScore\(.*\), product of:/) do |instance, match|
            instance.available_children = 
              [
                Element::Auto::Boost,
                Element::Auto::QueryNorm
              ]
          end or
          when_match_for_version(metadata, 'auto',line, /\(NON-MATCH\) ConstantScore\(.*\) doesn't match id \d+/) do |instance, match|
            instance.available_children = []
          end
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::no_impact(self, @children)
        end

        def parse_details_post
          if @value =~ /ConstantScore\((.*)\)/
            add_attribute(:query, $1)
          end
        end
      end
    end
  end
end
