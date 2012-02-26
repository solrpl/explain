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
require 'solr_result'
require 'digest/md5'

# Query translation model
class Explain < ActiveRecord::Base
  #after_initialize :calculate_explain
  before_create :generate_code
  before_create :check_if_valid
  validates_presence_of :plan

  # Convert to HTTP parameters - use "code" key
  def to_param
    code
  end

  # Array with list of strings explaining parsing
  def info(status)
    calculate_explain
    @result.info(status)
  end

  def result
    calculate_explain
    @result
  end


  private

  def calculate_explain
    if @calculated
      return
    end
    if plan && !@result
      parser = SolrResult::Parser.parser
      @result = parser.parse(plan)
      if public
        @result.add_info SolrResult::Info.new(:info, 'explain.show.public')
      end
    end
    @calculated = true
  end

  def generate_code
    self.code = rand(36**8).to_s(36)
    # long version self.code = Digest::MD5.hexdigest("solr" + Time.now.to_f.to_s)
  end

  def check_if_valid
    if result && result.parsed?
      self.verified = true
    else
      self.verified = false
      self.public = false
    end
    true
  end

end
