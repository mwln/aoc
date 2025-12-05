#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/client'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-d', '--day=DAY', Integer, 'day to submit') do |day|
    options[:day] = day
  end
  opts.on('-p', '--part=PART', Integer, 'part to submit (1 or 2)') do |part|
    options[:part] = part
  end
end.parse!

year = 2025
day = options[:day]
part = options[:part]

unless day && part
  warn 'usage: ruby scripts/submit.rb -d 1 -p 2'
  exit 1
end

solution_file = "days/#{day}.rb"
unless File.exist?(solution_file)
  warn "no solution file found: #{solution_file}"
  exit 1
end

client = Client.new
input_path = ".cache/#{year}/#{day}/input.txt"

client.fetch_input(year, day) unless File.exist?(input_path)

File.delete('input.txt') if File.symlink?('input.txt')
File.symlink(input_path, 'input.txt')

require_relative "../days/#{day}"

class_name = "Day#{day.to_s.rjust(2, '0')}"
solution = Object.const_get(class_name).new

answer = case part
         when 1 then solution.part_one
         when 2 then solution.part_two
         else
           warn "invalid part: #{part}"
           exit 1
         end

puts "submitting answer: #{answer}"

response_html = client.submit_answer(year, day, part, answer)

require 'nokogiri'
require 'json'

doc = Nokogiri::HTML(response_html)
message = doc.at('article')&.text&.strip || doc.at('main')&.text&.strip

if message
  puts "\nresponse:"
  puts message
else
  puts "\nraw response:"
  puts response_html
end

stats_file = '.cache/stats.json'
stats = File.exist?(stats_file) ? JSON.parse(File.read(stats_file)) : {}
stats[year.to_s] ||= {}
stats[year.to_s][day.to_s] ||= {}
stats[year.to_s][day.to_s]["part#{part}"] ||= { attempts: 0, correct: false }

stats[year.to_s][day.to_s]["part#{part}"][:attempts] += 1

if message&.include?("That's the right answer")
  stats[year.to_s][day.to_s]["part#{part}"][:correct] = true
end

File.write(stats_file, JSON.pretty_generate(stats))
