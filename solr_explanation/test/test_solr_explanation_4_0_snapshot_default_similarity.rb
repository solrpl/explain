#!/usr/bin/ruby -w

$:.unshift "#{File.expand_path( File.dirname( __FILE__ ) )}/../lib"

require 'test/unit'
require 'solr_explanation'

class SolrExplanation_4_0SnapshotDefaultSimilarityTest < Test::Unit::TestCase

  def get_explain(file)
    content = File.read(file)
    lines = content.split(/\r?\n/)
    puts "Check: #{lines.shift}"
    content = lines.join("\n")
    metadata = SolrExplanation::Metadata.new(:id => 'P_164345', :version => 'auto')
    parser = SolrExplanation::Parser.parser(metadata)
    explain = parser.parse(content)
  end

  
  files = Dir.glob('data/4.0-snapshot/DefaultSimilarity/*.txt')
  files.each_with_index do |x, idx|
    define_method "test_#{idx}" do
      puts "File: #{x}"
      result = get_explain x
      assert_not_nil result
    end
  end

end
