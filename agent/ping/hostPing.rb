#!/usr/bin/ruby

require "fileutils"

host=ARGV[0]
hostname=ARGV[1]
if hostname == nil then
  hostname = host
end

cmd = "ping -c10 -n #{host}"
print "Running #{cmd}"
now = Time.now
output = `#{cmd}`
print output

output =~ /(\d+) packets transmitted, (\d+) received,/

pkt_recd = $2
output =~ /rtt.*= (\d+\.\d+)\/(\d+\.\d+)\/(\d+\.\d+)/
rtt_min = $1
rtt_avg = $2
rtt_max = $3

date_dir = now.strftime("%Y-%m-%d") 
hour = now.strftime("%H")
output_dir = "logs/#{date_dir}"
FileUtils.mkdir output_dir unless File.exists?(output_dir)
open("#{output_dir}/#{hostname}-#{date_dir}-#{hour}.log",'a') do |f|
  f.print "\n#{now.to_i}|#{pkt_recd}|#{rtt_min}|#{rtt_avg}|#{rtt_max}"
end
