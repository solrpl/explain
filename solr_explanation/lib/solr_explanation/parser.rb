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
require 'solr_explanation/elements/root4_0'
require 'solr_explanation/elements/root_universal'

module SolrExplanation
  # Implementation of solr explain information parser.
  class Parser
    def initialize(metadata, root)
      @metadata = metadata
      @root_type = root
    end

    # Creates a new parser based on environment description given by metadata.
    def self.parser(metadata)
      implementation = case metadata.version
                        when '3.4' then Element::Root3_4
                        when '4.0' then Element::Root4_0
                        when '3.0' then Element::Root3_4
                        when 'auto' then Element::RootUniversal
                        else raise "Unsupported version: #{metadata[:version]}"
                      end

      Parser.new(metadata, implementation)
    end

    # Parses explain information given as text.
    # Returns tree wrapped by root element
    def parse(content)
      $Log.info('Start Parsing')
      lines = content.strip.split(/\r?\n/)
      root = @root_type.new(@metadata)
      root.build(@metadata, lines)
      root.post_process
      root
    end
  end
end
