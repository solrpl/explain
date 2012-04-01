#!/usr/bin/ruby -w

$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"

require 'test/unit'
require 'rubygems'
require 'solr_explanation'
require 'pp'

class SolrExplanation_3_4Test < Test::Unit::TestCase
  def get_explain(file)
    content = File.read("#{File.dirname(__FILE__)}/data/3.4/#{file}.txt")
    lines = content.split(/\r?\n/)
    puts "Check: #{lines.shift}"
    content = lines.join("\n")
    metadata = SolrExplanation::Metadata.new(:id => 'P_164345', :version => 'auto')
    parser = SolrExplanation::Parser.parser(metadata)
    explain = parser.parse(content)
  end

  def test_parse_001
    explain = get_explain '001'
    pp explain
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(1.0, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(1.0, explain.children[0].score)
    assert_equal('*:*', explain.attribute(:query))
  end

  def test_parse_002
    explain = get_explain '002'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(1.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(10.0, explain.children[0].score)
    assert_equal(0.1, explain.children[1].score)
    assert_equal('*:*^10.0', explain.attribute(:query))
  end

  def test_parse_003
    explain = get_explain '003'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(100.48211, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
    assert_equal(0.99999994, explain.children[0].score)
    assert_equal(100.48212, explain.children[1].score)
  end

  def test_parse_004
    explain = get_explain '004'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(3, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(0, explain.children[2].children.length)
    assert_equal(0, explain.children[0].score)
    assert_equal(3.8332133, explain.children[1].score)
    assert_equal(32.0, explain.children[2].score)
  end

  def test_parse_005
    explain = get_explain '005'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(142.10316, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(2, explain.children[1].children.length)
    assert_equal(71.05158, explain.children[0].score)
    assert_equal(71.05158, explain.children[1].score)
  end

  def test_parse_006
    explain = get_explain '006'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(63.675232, explain.children[0].score)
    assert_equal(0.0, explain.children[1].score)
  end

  def test_parse_007
    explain = get_explain '007'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(200.96422, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
    assert_equal(0.99999994, explain.children[0].score)
    assert_equal(200.96423, explain.children[1].score)
    explain.debug
    pp explain.items_with :leaf
  end

  def test_parse_008
    explain = get_explain '008'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
    assert_equal(1.0000001, explain.children[0].score)
    assert_equal(0.0, explain.children[1].score)
  end

  def test_parse_009
    explain = get_explain '009'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(3, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(2, explain.children[1].children.length)
    assert_equal(1, explain.children[2].children.length)
    assert_equal(71.05158, explain.children[0].score)
    assert_equal(71.05158, explain.children[1].score)
    assert_equal(0.0, explain.children[2].score)
  end

  def test_parse_010
    explain = get_explain '010'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(1.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(1.0, explain.children[0].score)
    assert_equal(1.0, explain.children[1].score)
  end

  def test_parse_011
    explain = get_explain '011'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(0, explain.children.length)
  end

  def test_parse_012
    explain = get_explain '012'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(47.872086, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(1, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(95.74417, explain.children[0].score)
    assert_equal(0.5, explain.children[1].score)
  end

  def test_parse_013
    explain = get_explain '013'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(1, explain.children[1].children.length)
    assert_equal(95.74417, explain.children[0].score)
    assert_equal(0.0, explain.children[1].score)
  end

  def test_parse_014
    explain = get_explain '014'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
    assert_equal(0.99999994, explain.children[0].score)
    assert_equal(0.0, explain.children[1].score)
  end

  def test_parse_015
    explain = get_explain '015'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(142.10315, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(3, explain.children[1].children.length)
    assert_equal(0.99999994, explain.children[0].score)
    assert_equal(142.10316, explain.children[1].score)
  end

  def test_parse_016
    explain = get_explain '016'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(83.606186, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(83.606186, explain.children[0].score)
    assert_equal(0.8320504, explain.children[0].children[0].score)
    assert_equal(100.48212, explain.children[0].children[1].score)
  end

  def test_parse_017
    explain = get_explain '017'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(87.020065, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(2, explain.children[1].children.length)
    assert_equal(29.006687, explain.children[0].score)
    assert_equal(58.013374, explain.children[1].score)
    assert_equal(58.013374, explain.children[0].children[0].score)
    assert_equal(0.5, explain.children[0].children[1].score)
  end

  def test_parse_018
    explain = get_explain '018'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(2, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(0, explain.children[1].children.length)
    assert_equal(0.0, explain.children[0].score)
    assert_equal(0.0, explain.children[1].score)
  end

  def test_parse_019
    explain = get_explain '019'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(75.04599, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(75.04599, explain.children[0].score)
    assert_equal(43.960922, explain.children[0].children[0].score)
    assert_equal(31.085068, explain.children[0].children[1].score)
  end

  def test_parse_020
    explain = get_explain '020'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(0.0, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(0, explain.children[0].children.length)
    assert_equal(0.0, explain.children[0].score)
  end

  def test_parse_021
    explain = get_explain '021'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(19.698519, explain.score)
    assert_equal(1, explain.children.length)
    assert_equal(2, explain.children[0].children.length)
    assert_equal(19.698519, explain.children[0].score)
    assert_equal(39.397038, explain.children[0].children[0].score)
    assert_equal(0.5, explain.children[0].children[1].score)
  end

  def test_parse_022
    explain = get_explain '022'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(61.47568, explain.score)
  end

  def test_parse_023
    explain = get_explain '023'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(58.419456, explain.score)
  end

  def test_parse_024
    explain = get_explain '024'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(62.025658, explain.score)
  end

  def test_parse_025
    explain = get_explain '025'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(62.34016, explain.score)
  end

  def test_parse_026
    explain = get_explain '026'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(2182.031, explain.score)
  end

  def test_parse_027
    explain = get_explain '027'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(2.6433713, explain.score)
  end

  def test_parse_028
    explain = get_explain '028'
    assert_not_nil explain
    assert_equal('P_164345', explain.doc)
    assert_equal(1.0, explain.score)
  end
end
