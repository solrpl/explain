#!/usr/bin/ruby -w

$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"

require 'test/unit'
require 'solr_explanation'

class SolrExplanation_3_0Test < Test::Unit::TestCase
  def get_explain(file)
    content = File.read("data/3.0/#{file}.txt")
    metadata = SolrExplanation::Metadata.new(:id => 'P_164345', :version => 'auto')
    parser = SolrExplanation::Parser.parser(metadata)
    explain = parser.parse(content)
  end

  def test_parse_1
    explain = get_explain '001'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.8621642, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(0.8621642, explain.children[0].score)
    explain.debug
  end

  def test_parse_2
    explain = get_explain '002'
    assert_not_nil explain
    assert_equal(1.6506158, explain.score)
    assert_equal(2, explain.children.length)
  end
  
  def test_parse_3
    explain = get_explain '003'
    assert_not_nil explain
    assert_equal(36.50278, explain.score)
    assert_equal(2, explain.children.length)
  end

  def test_parse_4
    explain = get_explain '004'
    assert_not_nil explain
    assert_equal(0.524427, explain.score)
    assert_equal(2, explain.children.length)
  end
  def test_parse_5
    explain = get_explain '005'
    assert_not_nil explain
    assert_equal(5.8746934, explain.score)
    assert_equal(2, explain.children.length)
  end

end
