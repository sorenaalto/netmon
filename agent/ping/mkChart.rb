#!/usr/bin/ruby

require 'gchart'

host="8.8.8.8"
max_points = 320

rtt_min = []
rtt_avg = []
rtt_max = []

File.open("#{host}.log",'r').each_line do |line|
  tokens = line.split(/\|/)
  rtt_min << tokens[2].to_f
  rtt_avg << tokens[3].to_f
  rtt_max << tokens[4].to_f
end

if rtt_min.length > max_points then
  start = rtt_min.length-max_points
  rend = rtt_min.length
  rtt_min = rtt_min[start,rend]
  rtt_avg = rtt_avg[start,rend]
  rtt_max = rtt_max[start,rend]
end

gUrl = Gchart.line(:size => "640x320",
                   :title => "#{host} RTT min/avg/max",
		   :legend => ["min","avg","max"],
	 	   :axis_with_labels => ['x','y'],
		   :data => [rtt_min,rtt_avg,rtt_max],
                   :line_colors =>"00FF00,0000FF,FF0000",
		   :min_value => 0, :max_value => 1000)
print gUrl
