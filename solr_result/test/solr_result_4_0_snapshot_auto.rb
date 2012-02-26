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

class SolrResult_4_0SnapshotAutoTest < Test::Unit::TestCase

  def get_result(file)
    content = File.read("data/4.0-snapshot-auto/#{file}.xml")
    parser = SolrResult::Parser.parser
    result = parser.parse(content)
  end

  (0..1041).each do |x|
    next if [21, 25, 27, 29, 32, 33, 36, 37, 54, 55, 67, 68].member? x
    define_method "test_#{x}" do
      puts "File: #{x}"
      result = get_result x
      assert_not_nil result
      assert result.parsed?
    end
  end

end
