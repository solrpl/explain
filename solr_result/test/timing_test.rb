#!/usr/bin/ruby -w
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
$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"
$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../../solr_explanation/lib"

require 'rubygems'
require 'test/unit'
require 'pp'
require 'solr_result/timing'

class TimingTest < Test::Unit::TestCase

  def test_parse_001
    input = {
      :prepare => {
        :"org.apache.solr.handler.component.StatsComponent" => {:time => 0.0 },
        :"org.apache.solr.handler.component.DebugComponent" => {:time => 0.0},
        :time => 1.0,
        :"org.apache.solr.handler.component.QueryComponent" => {:time => 1.0},
        :"org.apache.solr.handler.component.FacetComponent" => {:time => 0.0},
        :"org.apache.solr.handler.component.HighlightComponent" => {:time => 0.0},
        :"org.apache.solr.handler.component.MoreLikeThisComponent" => {:time => 0.0}
      },
      :process => {
        :"org.apache.solr.handler.component.StatsComponent" => {:time => 0.0},
        :"org.apache.solr.handler.component.DebugComponent" => {:time => 2.0},
        :time => 8.0,
        :"org.apache.solr.handler.component.QueryComponent" => {:time => 6.0},
        :"org.apache.solr.handler.component.FacetComponent" => {:time => 0.0},
        :"org.apache.solr.handler.component.HighlightComponent" => {:time => 0.0},
        :"org.apache.solr.handler.component.MoreLikeThisComponent" => {:time => 0.0}
      },
      :time => 9.0
    }

    timing = SolrResult::Timing.create(input)
    pp timing
    assert_not_nil timing
    assert_equal(2, timing.components.length)

    prepare = timing[:prepare]
    process = timing[:process]

    assert_equal(1, prepare.time)
    assert_equal(8, process.time)
    assert_equal(6, prepare.components.length)
    assert_equal(6, process.components.length)

    assert_equal(0, prepare[:"org.apache.solr.handler.component.StatsComponent"].time)
    assert_equal(1, prepare[:"org.apache.solr.handler.component.QueryComponent"].time)

    assert_equal(0, process[:"org.apache.solr.handler.component.StatsComponent"].time)
    assert_equal(2, process[:"org.apache.solr.handler.component.DebugComponent"].time)
    assert_equal(6, process[:"org.apache.solr.handler.component.QueryComponent"].time)
    assert_equal(0, process[:"org.apache.solr.handler.component.StatsComponent"].time)




#    assert result.parsed?
#    assert_equal(50, result.docs.length)
#    assert_equal(50, result.docs(:found).length)
#    assert_equal(0, result.docs(:other).length)
#    assert_equal(88, result.found)
#    assert result.params.on?(:debugQuery)
  end
end
