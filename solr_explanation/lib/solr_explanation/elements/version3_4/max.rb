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
require 'solr_explanation/elements/root3_4'

module SolrExplanation
  module Element
    module Version3_4
      class Max < Explanation
        
        def available_children
          Element::ROOT_ELEMENTS
        end

        def self.matches?(line)
          line =~ Explanation.regexp(/\(MATCH\) max( plus \d+\.{0,1}\d* times others)? of:/)
        end

        def parse_details_post
          tie = 0
          if @value =~ /plus (\d+\.{0,1}\d*) times/
            tie = $1.to_f
          end
          add_attribute(:tie, tie)
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::max(imp, attribute(:tie), @children)
        end
      end
    end
  end
end
