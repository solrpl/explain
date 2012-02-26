#!/usr/bin/ruby -w

$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"

require 'test/unit'
require 'solr_explanation'

class SolrExplanation_4_0Test < Test::Unit::TestCase
  def get_explain(file)
    content = File.read("data/4.0/#{file}.txt")
    metadata = SolrExplanation::Metadata.new(:id => 'P_164345', :version => 'auto')
    parser = SolrExplanation::Parser.parser(metadata)
    explain = parser.parse(content)
  end

  def test_parse_001
    explain = get_explain '001'
    explain.metadata.version
    assert_not_nil explain
    assert_equal('4.', explain.metadata.version)
    assert_equal('P_164345', explain.metadata[:id])
    assert_equal(0.6495038, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(0.6495038, explain.children[0].score)
    assert_equal(3, explain.children[0].children.length)
    assert_equal(1, explain.children[0].children[0].children.length)
    assert_equal(0, explain.children[0].children[1].children.length)
    assert_equal(0, explain.children[0].children[2].children.length)
  end
end

