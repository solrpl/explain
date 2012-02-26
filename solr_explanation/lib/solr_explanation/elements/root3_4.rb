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
require 'solr_explanation/elements/version3_4/match_all_docs_query'
require 'solr_explanation/elements/version3_4/weight'
require 'solr_explanation/elements/version3_4/field_weight'
require 'solr_explanation/elements/version3_4/boolean_query'
require 'solr_explanation/elements/version3_4/constant_score'
require 'solr_explanation/elements/version3_4/constant_score_query'
require 'solr_explanation/elements/version3_4/product'
require 'solr_explanation/elements/version3_4/max'
require 'solr_explanation/elements/version3_4/function_query'
require 'solr_explanation/elements/version3_4/boosted_query'

module SolrExplanation
  module Element

    ROOT_ELEMENTS = 
        [
          Element::Version3_4::MatchAllDocsQuery,
          Element::Version3_4::Weight,
          Element::Version3_4::FieldWeight,
          Element::Version3_4::BooleanQuery,
          Element::Version3_4::ConstantScore,
          Element::Version3_4::ConstantScoreQuery,
          Element::Version3_4::Product,
          Element::Version3_4::Max,
          Element::Version3_4::FunctionQuery,
          Element::Version3_4::BoostedQuery,
        ]

    class Root3_4 < Root


      def available_children
        ROOT_ELEMENTS
      end
    end
  end
end
