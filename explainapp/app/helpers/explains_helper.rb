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
module ExplainsHelper

  def as_percent(number)
    if number == 0
      return '-'
    end
    percent = number * 100
    if (percent > 0.1)
      number_to_percentage(percent, :precision => 2, :strip_insignificant_zeros => true)
    else
      '< 0.1%'
    end
  end

  def render_explanation_for_doc(explain, doc)
    explanation = doc.explanation
    s = ''
    s += render(:partial => 'explains/explain_description_header', :locals => { :doc => doc })
    s += render_if_exists(explanation_view(explanation), 'explains/description', { :locals => {:explanation => explanation.explanation }})
    s += render(:partial => 'explains/explain_description_footer', :locals => { :doc => doc, :explanation => explanation })
    s.html_safe
  end

  def explanation_view(explanation)
    puts "Asking for: #{explanation} return: #{'explains/description/' + explanation.class.to_s.gsub(/.*::/,'').underscore}"
    'explains/description/' + explanation.class.to_s.gsub(/.*::/,'').underscore
  end

  def render_if_exists(partial, default, options)
    #FIXME better use file checking becase errors in template will be silently ignored
    begin
      render({:partial => partial }.merge  options).html_safe
    rescue ActionView::MissingTemplate => e
      puts "no found: #{partial}: #{e}"
      render({:partial => default }.merge options).html_safe
    end
  end

  def render_explain_description(explain, type)
    return #TODO
    s = ''
    if explain.result.debug[type] && explain.result.debug[type].length > 0
      mkey = main_key(explain)
      s += render(:partial => 'explains/explains_description_header')
      explain.result.debug[type].each_pair do |key, val|
        s += render(:partial => 'explains/explain_description_header', :locals => { :mkey => mkey, :key => key })
        s += render_if_exists(explanation_view(val.root), 'explains/description', {:locals => { :description => val.root, :mkey => main_key(explain), :key => key }})
        s += render(:partial => 'explains/explain_description_footer', :locals => { :mkey => mkey, :key => key, :description => val.root })
      end
      s += render(:partial => 'explains/explains_description_footer')
    end
    s.html_safe
  end

 def main_key(explain)
    if explain.result.main_key
      explain.result.main_key
    else
      '(unknown unique key)'
    end
  end

  # Groups explains after creation and executes block for every group
  def group_by_day(explains)
    explains.group_by{ |e| e.created_at.beginning_of_day.strftime("%Y-%m-%d")}.each_pair do |group, values|
      yield group, values
    end
  end

  def show_chart_for_explanation(explanation)
    if explanation.score == 0
      return
    end
    data = explanation.items_with(:leaf).collect{|x| [x.short_description, number_with_precision(x.impact * 100, :precision => 2, :strip_insignificant_zeros => true).to_f]}
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.options[:title][:text] = "Explain components"
      f.series(:type => "pie", :name => 'Pie', :data => data)
      f.options[:chart][:width] = 650;
    end

    high_chart("chart_exp_#{explanation.doc}", chart) do
      "options.tooltip.formatter = function() { return this.point.name + ' ('+ this.y +'%)';}".html_safe
    end
  end

  def show_chart_for_performance(label,timing)
    return unless timing && timing.components.length > 0
    data = timing.components.find_all{|comp| timing[comp].time > 0}.collect do |comp|
      [t("solr.result.component.#{comp.to_s}", :default => comp.to_s), timing[comp].time]
    end
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.options[:title][:text] = label
      f.series(:type => "pie", :name => label, :data => data)
      f.options[:chart][:width] = 650;
    end

    high_chart("chart_perf_#{timing.object_id}", chart) do
      "options.tooltip.formatter = function() { return this.point.name + ' ('+ this.y +'ms)';}".html_safe
    end
  end
end
