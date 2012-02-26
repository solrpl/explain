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
require 'solr_explanation/elements/root3_4'
require 'solr_explanation/elements/version3_4/weight'
require 'solr_explanation/elements/version4/weight'
require 'pp'

module SolrExplanation
  module Element
    class Root4_0 < Root

      def available_children
        pp ROOT_ELEMENTS - [Element::Version3_4::Weight] + [Element::Version4::Weight]
        ROOT_ELEMENTS - [Element::Version3_4::Weight] + [Element::Version4::Weight]
      end
    end
  end
end
