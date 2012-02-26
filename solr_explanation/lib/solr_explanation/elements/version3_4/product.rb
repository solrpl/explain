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
require 'solr_explanation/elements/version3_4/boolean_query'
require 'solr_explanation/elements/version3_4/coord'

module SolrExplanation
  module Element
    module Version3_4
      class Product < Explanation
        
        def available_children
          [
            Element::Version3_4::BooleanQuery,
            Element::Version3_4::Coord
          ]
        end

        def self.matches?(line)
          line =~ Explanation.regexp(/\((NON-)?MATCH\) product of:/)
        end

        def parse_details_post
          add_attribute(:short_description, "product of the following:")
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::sum(imp, @children)
        end
      end
    end
  end
end
