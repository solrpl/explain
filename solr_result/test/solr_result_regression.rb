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
require 'solr_explanation'
require 'solr_result'

class SolrResultRegressionTest < Test::Unit::TestCase

  def get_result(file)
    content = File.read("data/3.4/#{file}.xml")
    parser = SolrResult::Parser.parser
    result = parser.parse(content)
  end

  # simple query
  def test_bad_xml
    input = 'explainOther=id:3007WFP&debugQuery=true&indent=on&q=*:*&rows=10'
    result = SolrResult::Parser.parser.parse(input)

    assert_not_nil result
    assert !result.parsed?
    assert_equal(0, result.debug.timing.time)
  end

end
