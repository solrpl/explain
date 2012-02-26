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
require 'solr_explanation/elements/version3_4/idf'
require 'solr_explanation/elements/version3_4/tf'
require 'solr_explanation/elements/version3_4/field_norm'

module SolrExplanation
  module Element
    module Version3_4
      class FieldWeight < Explanation

        def available_children
          [
            Element::Version3_4::Idf,
            Element::Version3_4::Tf,
            Element::Version3_4::FieldNorm
          ]
        end

        def self.matches?(line)
          line =~ Explanation.regexp(/\((NON-)?MATCH\) fieldWeight\(.*\), product of:/) or
          line =~ Explanation.regexp(/fieldWeight\(\S+:".*" in \d+\), product of:/)
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::no_impact(self, @children)
        end

        def parse_details_post
          if @value =~ /fieldWeight\((.*)\)/
            add_attribute(:query, $1)
          end
        end

      end
    end
  end
end
