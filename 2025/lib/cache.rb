# frozen_string_literal: true

require 'fileutils'

class Cache
  def initialize(cache_dir = '.cache')
    @cache_dir = cache_dir
  end

  def day_dir(year, day)
    File.join(@cache_dir, year.to_s, day.to_s)
  end

  def html_path(year, day)
    return nil unless @cache_dir

    File.join(day_dir(year, day), 'puzzle.html')
  end

  def input_path(year, day)
    return nil unless @cache_dir

    File.join(day_dir(year, day), 'input.txt')
  end

  def part_path(year, day, part)
    return nil unless @cache_dir

    File.join(day_dir(year, day), "part#{part}.md")
  end

  def examples_dir(year, day)
    return nil unless @cache_dir

    File.join(day_dir(year, day), 'examples')
  end

  def read_html(year, day)
    path = html_path(year, day)
    File.read(path) if path && File.exist?(path)
  end

  def write_html(year, day, content)
    path = html_path(year, day)
    return unless path

    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def read_input(year, day)
    path = input_path(year, day)
    File.read(path) if path && File.exist?(path)
  end

  def write_input(year, day, content)
    path = input_path(year, day)
    return unless path

    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def write_part(year, day, part, content)
    path = part_path(year, day, part)
    return unless path

    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end

  def write_examples(year, day, examples)
    dir = examples_dir(year, day)
    return unless dir

    FileUtils.mkdir_p(dir)
    examples.each_with_index do |example, i|
      File.write(File.join(dir, "#{i + 1}.txt"), example)
    end
  end

  def invalidate_html(year, day)
    html_file = html_path(year, day)
    part2_file = part_path(year, day, 2)

    File.delete(html_file) if html_file && File.exist?(html_file)
    File.delete(part2_file) if part2_file && File.exist?(part2_file)
  end
end
