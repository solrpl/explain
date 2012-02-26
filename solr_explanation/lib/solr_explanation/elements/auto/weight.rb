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
require 'solr_explanation/elements/auto/score'
require 'solr_explanation/elements/auto/query_weight'
require 'solr_explanation/elements/auto/field_weight'

#./lucene/src/java/org/apache/lucene/search/MultiPhraseQuery.java
#./lucene/src/java/org/apache/lucene/search/spans/SpanWeight.java
#./lucene/src/java/org/apache/lucene/search/PhraseQuery.java
#./lucene/src/java/org/apache/lucene/search/TermQuery.java

module SolrExplanation
  module Element
    module Auto
      class Weight < Explanation
        attr_accessor :similarity

        def self.try_create(metadata, line)
          when_match_for_version(metadata, '3.',line, /(\((NON-)?MATCH\) )?weight\(.* in \d+\), product of:/) do |instance, match| 
            instance.available_children = 
              [
                Element::Auto::QueryWeight,
                Element::Auto::FieldWeight
              ]
          end or
          when_match_for_version(metadata, '4.',line, /(?:\((?:NON-)?MATCH\) )?weight\(.* in \d+\) \[(\S+)\], result of:/) do |instance, match|
            instance.similarity = match[1]
            if instance.similarity == 'DefaultSimilarity'
              instance.available_children = 
                [
                  Element::Auto::Score,
                  Element::Auto::QueryWeight,
                  Element::Auto::FieldWeight
                ]
            else
              raise "Unknown similarity: #{instance.similarity}. Currently not supported."
            end
          end
        end

        def set_impact_for_children(imp)
          SolrExplanation::Impact::no_impact(self, @children)
        end

        def parse_details_post
          if @value =~ /weight\((.*) in \d+\)/
            add_attribute(:query, $1)
          end
        end
      end
    end
  end
end
