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
module SolrExplanation
  class Metadata

    def initialize(data)
      @meta = data
    end

    def [](id)
      @meta[id]
    end

    def version
      if @meta[:version]
        @meta[:version]
      else
        'auto'
      end
    end

    def version=(ver)
      if @meta[:version] == 'auto'
        @meta[:version] = ver
      else
        if ver != @meta[:version]
          raise "Cannot set version to: #{ver}. Current version is not 'auto'"
        end
      end
    end

    def compatible_with(ver)
      return true if ver == 'auto'
      return true if version == 'auto'
      return true if version =~ Regexp.new(ver)
    end
  end
end
