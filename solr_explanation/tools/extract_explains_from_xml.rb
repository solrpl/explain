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
require 'rubygems'
require 'rexml/document'
require 'pp'

class Document

  def initialize(file)
    @file = file
  end

  def parse
    begin
      content = File.read(@file)
      doc = REXML::Document.new(content)
      out = []
      doc.elements.each("/response/lst[@name='debug']/lst[@name='explain']/str") do |item|
        out << item.text
      end
      out
    rescue REXML::ParseException => e
      puts "Error: "
      raise e
    end
  end
end

ARGV.each do |item|
  doc = Document.new(item)
  items  = doc.parse
  if items
    items.each_with_index do |expl, idx|
      File.open("#{item}-#{idx}.txt", 'w') {|f| f.write(expl.to_s) }
    end
  end
end
