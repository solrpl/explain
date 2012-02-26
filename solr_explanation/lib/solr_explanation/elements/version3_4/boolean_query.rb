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
require 'solr_explanation/elements/version3_4/no_match'
require 'solr_explanation/elements/version3_4/match_prohibited'

module SolrExplanation
  module Element
    module Version3_4
      class BooleanQuery < Explanation
        @avail = [
            Element::Version3_4::BooleanQuery
        ]

        def available_children
          @avail
        end

        def self.matches?(line)
          line =~ Explanation.regexp(/\((NON-)?MATCH\) sum of:/) or # if hit
          line =~ Explanation.regexp(/\(NON-MATCH\) Failure to meet condition\(s\) of required\/prohibited clause\(s\)/) or # if fail
          line =~ Explanation.regexp(/\(NON-MATCH\) Failure to match minimum number of optional clauses: \d+/) # mm
        end

        def parse_details_pre
          if @line =~ Explanation.regexp(/\(MATCH\) sum of:/) # if hit
            @avail = Element::ROOT_ELEMENTS
          end
          if @line =~ Explanation.regexp(/\(NON-MATCH\) Failure to meet condition\(s\) of required\/prohibited clause\(s\)/)
            @avail = Array.new(Element::ROOT_ELEMENTS)
            @avail << Element::Version3_4::NoMatch
            @avail << Element::Version3_4::MatchProhibited
          end
        end

        def parse_details_post
          add_attribute(:short_description, "sum of the following:")
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::sum(imp, @children)
        end
      end
    end
  end
end
