#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/client'
require_relative '../lib/parser'
require 'optparse'

options = { part: nil, example: false }
OptionParser.new do |opts|
  opts.on('-d', '--day=DAY', Integer, 'day of the problem') do |day|
    options[:day] = day
  end
  opts.on('-p', '--part=PART', Integer, 'which part (1 or 2)') do |part|
    options[:part] = part
  end
  opts.on('-e', '--example', 'show examples') do
    options[:example] = true
  end
end.parse!

year = 2025
day = options[:day]
cache_dir = ".cache/#{year}/#{day}"

part1_cache = File.join(cache_dir, 'part1.md')
part2_cache = File.join(cache_dir, 'part2.md')

client = Client.new

client.fetch_puzzle(year, day) unless File.exist?(part1_cache)

client.fetch_puzzle(year, day, force_refresh: true) if options[:part] == 2 && !File.exist?(part2_cache)

if options[:example]
  examples_dir = File.join(cache_dir, 'examples')
  if Dir.exist?(examples_dir)
    example_files = Dir.glob(File.join(examples_dir, '*.txt')).sort
    if example_files.any?
      example_files.each_with_index do |file, i|
        puts "Example #{i + 1}:"
        puts File.read(file)
        puts unless i == example_files.length - 1
      end
    else
      warn 'no examples found'
      exit 1
    end
  else
    warn 'no examples found'
    exit 1
  end
elsif options[:part]
  file = File.join(cache_dir, "part#{options[:part]}.md")
  if File.exist?(file)
    puts File.read(file)
  else
    warn "part #{options[:part]} not available yet"
    exit 1
  end
else
  puts File.read(part1_cache) if File.exist?(part1_cache)

  if File.exist?(part2_cache)
    puts "\n---\n"
    puts File.read(part2_cache)
  end
end
