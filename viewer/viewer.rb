#!/usr/bin/ruby

require 'sinatra'
require 'set'
require 'gchart'

get '/' do
  'Howzit'
end

get '/dir' do
  out = ""
  Dir.new("logs/logs").each do |d|
    if d =~ /20\d\d-\d\d-\d\d/ then
      out << "\n<br><A HREF='/dir/#{d}'>#{d}</A>"
    end
  end
  return out
end

get '/dir/:date' do
  date = params[:date]
  out = "Listing for #{date}"
  hosts = SortedSet.new
  hours = SortedSet.new
  linkmap = {}
  Dir.new("logs/logs/#{date}").each do |h|
    if h =~ /(.*)-#{date}-(\d+)/ then
      host = $1
      hour = $2
      hosts << host
      hours << hour
      key = "#{host}:#{hour}"
      linkmap[key] = "<A HREF='/dir/#{date}/#{h}'>#{hour}</A>"
      print "\n #{key} -> #{linkmap[key]}"
    end
  end
  # render table of links for all hosts
  out << "\n<table border=1 cellspacing=0>"
  out << "\n<tr><th>hour</th>"
  hosts.each { |ept| out << "<th>#{ept}</th>" }
  out << "</tr>"
  hours.each do |h|
    out << "\n<tr><th>#{h}</th>"
    hosts.each do |ept|
      key = "#{ept}:#{h}"
      link = linkmap[key]
      if link == nil then
        out << "<td>.</td>"
      else
        out << "<td>#{link}</td>"
      end
    end
    out << "</tr>"
  end
  out << "\n</table>"
  return out
end

def makeChartUrl(filename) 
  rtt_min = []
  rtt_avg = []
  rtt_max = []

  File.open(filename,'r').each_line do |line|
    tokens = line.split(/\|/)
    rtt_min << tokens[2].to_f
    rtt_avg << tokens[3].to_f
    rtt_max << tokens[4].to_f    
  end

  max_ms = [5,10,50,100,500,1000]
  max_rtt = 1
  max_ms.each { |m| if rtt_max.max > m then max_rtt = m end }
  max_rtt = max_rtt * 2
  gUrl = Gchart.line(:size => "640x320",
                   :title => "#{filename} RTT min/avg/max",
                   :legend => ["min","avg","max"],
                   :axis_with_labels => ['x','y'],
                   :data => [rtt_min,rtt_avg,rtt_max],
                   :line_colors =>"00FF00,0000FF,FF0000",
                   :min_value => 0, :max_value => max_rtt)
  return gUrl
end

get '/dir/:date/:logfile' do
  date = params[:date]
  logfile = params[:logfile]
  out = "Logfile: #{logfile}"
  logpath = "logs/logs/#{date}/#{logfile}"
  gcUrl = makeChartUrl(logpath)
  out << "\n<div><img src='#{gcUrl}'></div>"
  out << "\n<pre>"
  File.new(logpath).each_line do |line|
    out <<  line
  end
  out << "\n</pre>"
  return out
end
