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
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'solr_explanation'

Gem::Specification.new do |s|
  s.name        = "solr_explanation"
  s.version     = SolrExplanation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marek Rogozinski"]
  s.email       = ["m.rogozinski@solr.pl"]
  s.homepage    = "http://solr.pl/"
  s.summary     = %q{Library for parsing solr debug information}
  s.description = %q{SolrExplanation is simple library for parsing information produced by lucene explain() call or contained in solr response.}

  s.rubyforge_project = "solr_explanation"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
