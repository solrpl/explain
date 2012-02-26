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

# ./lucene/src/java/org/apache/lucene/search/MatchAllDocsQuery.java
# HIT: (MATCH) MatchAllDocsQuery, product of:
# * boost # if boost != 1.0
# * queryNorm
module SolrExplanation
  module Element
    module Auto
      class MatchAllDocsQuery < Explanation
        def available_children
          [
            Element::Auto::Boost, #added if boost != 1.0
            Element::Auto::QueryNorm
          ]
        end

        def self.try_create(metadata, line)
          when_match_for_version(metadata, 'auto',line, /\(MATCH\) MatchAllDocsQuery, product of:/)
        end

        def parse_details_post
          boost = @children.find{|x| x.instance_of? Element::Auto::Boost}
          if boost
            add_attribute(:query, "*:*^#{boost.score}")
          else
            add_attribute(:query, "*:*")
          end
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::no_impact(self, @children)
        end
      end
    end
  end
end
