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
require 'solr_explanation/elements/auto/term_freq'
require 'solr_explanation/elements/auto/phrase_freq'

module SolrExplanation
  module Element
    module Auto
      class Tf < Explanation

        def self.try_create(metadata, line)
          when_match_for_version(metadata, 'auto',line, /tf\(termFreq\(\S+:.*\)=\d+\)/) or
          when_match_for_version(metadata, 'auto',line, /tf\(phraseFreq=\d+\.{0,1}\d*\)/) or
          when_match_for_version(metadata, '4.',line, /tf\(freq=\d+\.{0,1}\d*\), with freq of:/) do |instance, match|
              instance.available_children = 
                [
                  Element::Auto::TermFreq,
                  Element::Auto::PhraseFreq
                ]
          end
        end
      end
    end
  end
end
