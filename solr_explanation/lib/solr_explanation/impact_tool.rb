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

  module Impact
    def self.sum(imp, children)
      sum = children.reduce(0){|s,x| s + x.score}
      unit = imp/sum
      children.each do |child|
        child.impact = child.score * unit
      end
    end

    def self.max(imp, tie, children)
      max = children.max_by{|x| x.score}
      unless tie
        tie = 0
      end
      all_max = children.find_all{|x| x.score == max.score}

      sum = children.reduce(0) do |s, x|
        if x.score == max.score
          s + x.score
        else
          s + tie * x.score
        end
      end

      unit = imp/sum

      children.each do |child|
        if child.score == max.score
          child.impact = child.score * unit
        else
          child.impact = child.score * unit * tie
        end
      end
    end

    def self.no_impact(item, children)
      item.add_capability(:leaf)
    end
  end

end
