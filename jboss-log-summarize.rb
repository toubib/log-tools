#!/usr/bin/env ruby
# Summarize log4j logs

log_file = ARGV[0]
date = nil
head_line = nil
block_content = nil
head_list = {}
head_list_count = {}
head_list_time = {}

File.foreach log_file do |line|

	line.strip!
	#set date var
	date = line.sub(/ .*/,'') unless ! date.nil?

	#test if new block
	if line =~ /^#{date}/

		#process previous block
		if ! head_line.nil?

			if ! block_content.nil?
				#p "#{block_content.hash} ### #{block_content}"
			end
		end

		#process new block
		head_line = line.sub(/^#{date} \d{2}:\d{2}:\d{2},\d{3}/,'').gsub(/[0-9]+/,'*')
		head_time = line.sub(/^#{date} /,'').sub(/ .*/,'')

		if head_list[head_line.hash].nil?
			head_list[head_line.hash] = head_line
			head_list_count[head_line.hash] = 1
			head_list_time[head_line.hash] = []
		else
			head_list_count[head_line.hash] += 1
		end

		head_list_time[head_line.hash] << head_time

		block_content = []
		block_content << line

	#block content
	else
		block_content << line
	end

end

#p date

head_list_count.sort_by {|_key, value| value}.each do|hash, value|

	#set time array
	head_list_time_by_hour = [].fill(0,0,24)
	head_list_time[hash].each do |t|
		hour = t.sub(/:.*/,'').to_i
		head_list_time_by_hour[hour] += 1
	end

	print "\033[0;37m#{value}\033[0m\t#{head_list[hash]}\n\t\t"
	head_list_time_by_hour.each_index do |i|
		#print "#{i}h:#{head_list_time_by_hour[i]} "
		print "#{head_list_time_by_hour[i]} "
		print "\n\t\t" if i == 11
	end
	print "\n"
	#print "\t#{head_list_time[hash]}"
end
