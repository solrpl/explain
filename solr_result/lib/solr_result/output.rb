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
module SolrResult
  class Output
    attr_reader :found, :params, :debug

    def initialize
      @parsed = false
      @info = []
    end

    def attributes(arr)
      @docs = arr[:docs]
      @found = arr[:found]
      @params = arr[:params]
      @info = arr[:info]
      @parsed = arr[:parsed]
      @debug = arr[:debug]
      fill_info
    end

    def parsed?
      @parsed
    end

    def docs(type = nil) 
      if type && type == :found_and_other
        @docs.find_all{|x| x.type == type}
      elsif type
        @docs.find_all{|x| x.type == type || x.type == :found_and_other }
      else
        @docs
      end
    end

    def info(status = nil)
      if status
        @info.find_all{|x| x.status == status }
      else
        @info
      end
    end

    def add_info(info)
      @info << info
    end

    private
      
      def fill_info
        if @params.empty?
          @info << Info.new(:warning, 'solr.result.info.query.empty')
        else
          @info << Info.new(:info, 'solr.result.info.query.used', {:query => @params.params_string })
        end

        if @docs.empty?
          if @params[:explainOther]
            @info << Info.new(:warning, 'solr.result.info.baseResult.empty')
          else
            @info << Info.new(:warning, 'solr.result.info.result.empty')
          end
        end
      end

  end
end
