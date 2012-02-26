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
require 'solr_explanation/elements/tree_element'

module SolrExplanation
  module Element
    class Root < TreeElement
      attr_reader :metadata, :explanation

      def initialize(metadata)
        @metadata = metadata
        @explanation = nil
      end

      def score
        @explanation.score
      end

      def children
        @explanation.children
      end

      def items_with(cap)
        @explanation.items_with(cap)
      end

      def impact
        @explanation.impact
      end

      def doc
        @metadata[:id]
      end

      def debug(cap = nil)
        @explanation.debug(cap)
      end

      def attribute(a)
        @explanation.attribute(a)
      end

      def <<(item)
        if @explanation == nil
          @explanation = item
          return
        end
        raise "Root element cannot have more than one child"
      end

      def post_process
        @explanation.post_process
        @explanation.impact = 1.0
      end

    end
  end
end
