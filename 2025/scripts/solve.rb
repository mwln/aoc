#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/client'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-d', '--day=DAY', Integer, 'day to solve') do |day|
    options[:day] = day
  end
end.parse!

year = 2025
day = options[:day]

unless day
  warn 'please specify a day: ruby scripts/solve.rb -d 1'
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

system("ruby #{solution_file}")
