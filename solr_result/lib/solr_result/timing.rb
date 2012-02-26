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
module SolrResult
  class Timing
    attr_reader :time

    def self.create(data)
      if data.length == 1
        return Timing.new(data[:time])
      end
      t = Timing.new
      data.each_key do |key|
        next if key == :time
        t.add(key, data[key], data[key][:time])  
      end
      t
    end

    def initialize(time = 0)
      @time = time
      @components = {}
    end

    def add(name, val, time)
      @time += time
      v = Timing.create(val)
      @components[name] = v
    end

    def components
      @components.keys
    end

    def [](item)
      @components[item]
    end
  end
end
