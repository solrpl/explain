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
require 'solr_explanation/elements/auto/query_weight'
require 'solr_explanation/elements/auto/field_weight'

module SolrExplanation
  module Element
    module Auto
      class Score < Explanation
        def self.try_create(metadata, line)
          #0.74316853 = score(doc=1,freq=1.0 = phraseFreq=1.0'
          when_match_for_version(metadata, '4.',line, /score\(doc=\d+,freq=\d+(\.\d+)? = phraseFreq=\d+(\.\d+)?/) do |instance, match|
            instance.available_children =
              [
                Element::Auto::QueryWeight,
                Element::Auto::FieldWeight,
              ]
          end or
          # 0.6819344 = score(doc=5,freq=2.0 = termFreq=2.0
          when_match_for_version(metadata, '4.',line, /score\(doc=\d+,freq=\d+(\.\d+)? = termFreq=\d+(\.\d+)?/) do |instance, match|
            instance.available_children =
              [
                Element::Auto::QueryWeight,
                Element::Auto::FieldWeight,
              ]
          end
        end
      end
    end
  end
end
