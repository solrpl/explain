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
require 'lazy_high_charts'

class ExplainsController < ApplicationController
  # GET /explains
  # GET /explains.xml
  def index
    @explains = Explain.where(:public => true).order("created_at desc").page(params[:page]).per(40)
    @page = 'history'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @explains }
    end
  end

  # GET /explains/1
  # GET /explains/1.xml
  def show
    @page = 'show'
    @explain = Explain.find_by_code(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @explain }
    end
  end

  # GET /explains/new
  # GET /explains/new.xml
  def new
    @explain = Explain.new
    @page = 'new-explain'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @explain }
    end
  end

  # POST /explains
  # POST /explains.xml
  def create
    @explain = Explain.new(params[:explain])
    @page = 'new-explain'

    respond_to do |format|
      if @explain.save
        if @explain.verified
          format.html { redirect_to(@explain, :notice => 'Explain was successfully created.') }
          format.xml  { render :xml => @explain, :status => :created, :location => @explain }
        else
          format.html { redirect_to(@explain, :notice => 'Explain was NOT created because of errors.') }
          format.xml  { render :xml => @explain, :status => :created, :location => @explain }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @explain.errors, :status => :unprocessable_entity }
      end
    end
  end

end
