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

class SolrResultOtherTest < Test::Unit::TestCase

  def get_result(file)
    content = File.read("data/other/#{file}.xml")
    parser = SolrResult::Parser.parser
    result = parser.parse(content)
  end

  def test_parse_002
    result = get_result '002'
    assert_not_nil result
    assert result.parsed?
    assert_equal(4, result.docs.length)
    assert_equal(4, result.docs(:found).length)
    assert_equal(0, result.docs(:other).length)
    assert_equal(4, result.found)
    assert result.params.on?(:debugQuery)
    assert result.params.debug?
    assert_equal(:id, result.docs[0].key)
    assert_equal('48838193', result.docs[0].uniq_id)
  end

  def test_parse_003
    result = get_result '003'
    assert_not_nil result
    assert result.parsed?
    assert_equal(4, result.docs.length)
    assert_equal(4, result.docs(:found).length)
    assert_equal(0, result.docs(:other).length)
    assert_equal(4, result.found)
    assert result.params.on?(:debugQuery)
    assert result.params.debug?
    assert_equal(:id, result.docs[0].key)
    assert_equal('48838193', result.docs[0].uniq_id)
  end
end
