#!/usr/bin/ruby -w

$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"

require 'test/unit'
require 'solr_explanation'

class SolrExplanationOtherTest < Test::Unit::TestCase
  def get_explain(file)
    content = File.read("#{File.dirname(__FILE__)}/data/other/#{file}.txt")
    metadata = SolrExplanation::Metadata.new(:id => 'P_164345', :version => 'auto')
    parser = SolrExplanation::Parser.parser(metadata)
    explain = parser.parse(content)
  end

  def test_parse_001
    explain = get_explain '001'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(1.0, explain.score)
    assert_equal(1, explain.children.length)
  end

  def test_parse_002
    explain = get_explain '002'
    assert_not_nil explain
    assert_equal(2.0226068, explain.score)
    assert_equal(3, explain.children.length)
  end

  def test_parse_003
    explain = get_explain '003'
    assert_not_nil explain
    assert_equal(3.1857367, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(1.0, explain.children[0].score)
    assert_equal(10.194357, explain.children[0].children[0].score)
    assert_equal(0.09809349, explain.children[0].children[1].score)
    assert_equal(3.1857367, explain.children[1].score)
    assert_equal(1.0, explain.children[1].children[0].score)
    assert_equal(10.194357, explain.children[1].children[1].score)
    assert_equal(0.3125, explain.children[1].children[2].score)
  end

  def test_parse_004
    explain = get_explain '004'
    assert_not_nil explain
    assert_equal(1.0, explain.score)
    assert_equal(2, explain.children.length)
  end

  def test_parse_005
    explain = get_explain '005'
    assert_not_nil explain
    assert_equal(1.0, explain.score)
    assert_equal(2, explain.children.length)
  end

  def test_parse_006
    explain = get_explain '006'
    assert_not_nil explain
    assert_equal(1.0, explain.score)
    assert_equal(2, explain.children.length)
  end

  def test_parse_007
    explain = get_explain '007'
    assert_not_nil explain
    assert_equal(0.37328374, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0.16064762, explain.children[0].score)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[0].children[0].children.length)
    assert_equal(3, explain.children[0].children[1].children.length)
    assert_equal(0.21263614, explain.children[1].score)
    assert_equal(2, explain.children[1].children.length)
    assert_equal(2, explain.children[1].children[0].children.length)
    assert_equal(3, explain.children[1].children[1].children.length)
  end

  def test_parse_008
    explain = get_explain '008'
    assert_not_nil explain
    assert_equal(1.0152652, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
  end

  def test_parse_009
    explain = get_explain '009'
    assert_not_nil explain
    assert_equal(2.7630355, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(2, explain.children[0].children[0].children.length)
    assert_equal(3, explain.children[0].children[1].children.length)
    assert_equal(2, explain.children[1].children.length)
    assert_equal(2, explain.children[1].children[0].children.length)
    assert_equal(3, explain.children[1].children[1].children.length)
  end

  #FIXME: ten test do przemyślenia - podwójne fieldWeight
  def unsupported_without_indent_test_parse_010
    explain = get_explain '010'
    assert_not_nil explain
  end

  def test_parse_011
    explain = get_explain '011'
    assert_not_nil explain
    assert_equal(4.0347495, explain.score)
    assert_equal(4, explain.children.length)
    # TODO: więcej testów
  end

  #Do sprawdzenia - brak fieldNorm
  def block_test_parse_012
    explain = get_explain '012'
    assert_not_nil explain
    assert_equal(2.3797977, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(1.5483798, explain.children[0].score)
    assert_equal(2, explain.children[0].children.length)
    # TODO: więcej testów
  end

  def test_parse_013
    explain = get_explain '013'
    assert_not_nil explain
    assert_equal(1.8610218, explain.score)
    assert_equal(1, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_014
    explain = get_explain '014'
    assert_not_nil explain
    assert_equal(1.86102, explain.score)
    assert_equal(1, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_015
    explain = get_explain '015'
    assert_not_nil explain
    assert_equal(0.18895942, explain.score)
    assert_equal(3, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_016
    explain = get_explain '016'
    assert_not_nil explain
    assert_equal(0.8041408, explain.score)
    assert_equal(3, explain.children.length)
    # TODO: więcej testów
  end

  #TODO parsowanie nietrafionych
  def test_parse_017
    explain = get_explain '017'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_018
    explain = get_explain '018'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(3, explain.children.length)
    explain.debug
    # TODO: więcej testów
  end

  def test_parse_019
    explain = get_explain '019'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_020
    explain = get_explain '020'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(0, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_021
    explain = get_explain '021'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(0, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_022
    explain = get_explain '022'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(0, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_023
    explain = get_explain '023'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(0, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_024
    explain = get_explain '024'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    # TODO: więcej testów
  end

  def test_parse_025
    explain = get_explain '025'
    assert_not_nil explain
    assert_equal(6.0196667, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(6.0196667, explain.children[0].score)
    assert_equal(1, explain.children[0].children.length)
    assert_equal(3, explain.children[0].children[0].children.length)
  end

  def test_parse_026
    explain = get_explain '026'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0.0, explain.children[0].score)
    assert_equal(1, explain.children[0].children.length)
    assert_equal(2, explain.children[0].children[0].children.length)
  end

  def test_parse_027
    explain = get_explain '027'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0.0, explain.children[0].score)
    assert_equal(1, explain.children[0].children.length)
  end

  #TODO:
  def block_test_parse_028
    explain = get_explain '028'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0.0, explain.children[0].score)
    assert_equal(1, explain.children[0].children.length)
  end

  #TODO:
  def block_test_parse_029
    explain = get_explain '029'
    assert_not_nil explain
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0.0, explain.children[0].score)
    assert_equal(1, explain.children[0].children.length)
  end

  def test_parse_030
    explain = get_explain '030'
    assert_not_nil explain
    assert_equal(0.01695364, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(0.01695364, explain.children[0].score)
    assert_equal(2, explain.children[0].children.length)
  end

  def test_parse_031
    explain = get_explain '031'
    assert_not_nil explain
    assert_equal('P_164345', explain.metadata[:id])
    assert_equal(1.3200746, explain.score)
    assert_equal(2, explain.children.length)
  end


end

