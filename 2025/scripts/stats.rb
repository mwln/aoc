# frozen_string_literal: true

require 'json'
require 'colorize'
require 'optparse'

STATS_FILE = '.cache/stats.json'

options = {}
OptionParser.new do |opts|
  opts.on('-y', '--year=YEAR', Integer, 'year to show stats for') do |year|
    options[:year] = year
  end
end.parse!

YEAR = options[:year] || 2025

def load_stats
  return {} unless File.exist?(STATS_FILE)

  JSON.parse(File.read(STATS_FILE))
end

def scan_completions
  completions = { part1: [], part2: [] }

  (1..25).each do |day|
    solution_file = "days/#{day}.rb"
    next unless File.exist?(solution_file)

    content = File.read(solution_file)

    part1_stub = content.match?(/def part_one\s+#.*TODO.*\n\s+['"]0['"]/m)
    part2_stub = content.match?(/def part_two\s+#.*TODO.*\n\s+['"]0['"]/m)

    next if part1_stub

    if part2_stub
      completions[:part1] << day
    else
      completions[:part2] << day
    end
  end

  completions
end

def build_part_status(attempts, completed)
  status = ''
  status += ('.'.red * (attempts - 1)) if attempts > 1
  status += completed ? '*'.yellow : '_'.light_black
  status
end

def display_stats
  stats = load_stats
  current_year_stats = stats[YEAR.to_s] || {}
  completions = scan_completions

  all_days = (completions[:part1] + completions[:part2]).sort.uniq

  return if all_days.empty?

  all_days.each do |day|
    day_stats = current_year_stats[day.to_s] || {}
    part1_attempts = day_stats.dig('part1', 'attempts') || 0
    part2_attempts = day_stats.dig('part2', 'attempts') || 0

    part1_complete = completions[:part1].include?(day) || completions[:part2].include?(day)
    part2_complete = completions[:part2].include?(day)

    output = "#{day.to_s.rjust(2)}: "
    output += build_part_status(part1_attempts, part1_complete)
    output += build_part_status(part2_attempts, part2_complete)

    puts output
  end
end

display_stats
