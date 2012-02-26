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
require 'solr_explanation/elements/root'
require 'solr_explanation/elements/auto/match_all_docs_query'
require 'solr_explanation/elements/auto/weight'
require 'solr_explanation/elements/auto/field_weight'
require 'solr_explanation/elements/auto/boolean_query'
require 'solr_explanation/elements/auto/constant_score'
require 'solr_explanation/elements/auto/constant_score_query'
require 'solr_explanation/elements/auto/product'
require 'solr_explanation/elements/auto/max'
require 'solr_explanation/elements/auto/function_query'
require 'solr_explanation/elements/auto/boosted_query'
require 'solr_explanation/elements/auto/no_match_term'

module SolrExplanation
  module Element

    ROOT_ELEMENTS = 
        [
          Element::Auto::MatchAllDocsQuery,
          Element::Auto::Weight,
          Element::Auto::FieldWeight,
          Element::Auto::BooleanQuery,
          Element::Auto::ConstantScore,
          Element::Auto::ConstantScoreQuery,
          Element::Auto::Product,
          Element::Auto::Max,
          Element::Auto::FunctionQuery,
          Element::Auto::BoostedQuery,
          Element::Auto::NoMatchTerm,
        ]

    class RootUniversal < Root


      def available_children
        ROOT_ELEMENTS
      end
    end
  end
end
