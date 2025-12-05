# frozen_string_literal: true

require 'nokogiri'

class Parser
  attr_reader :title, :part1, :part2, :examples

  def initialize(html)
    @doc = Nokogiri::HTML(html)
    parse
  end

  def description
    [@part1, @part2].compact.join("\n\n")
  end

  def formatted_part1
    format_part(@title, @part1) if @part1
  end

  def formatted_part2
    format_part('Part Two', @part2) if @part2
  end

  private

  def parse
    main = @doc.at('main')
    return unless main

    day_descs = main.css('.day-desc')

    if day_descs[0]
      @title = day_descs[0].at('h2')&.text&.strip
      @part1 = extract_text_from_article(day_descs[0])
    end

    @part2 = extract_text_from_article(day_descs[1]) if day_descs[1]

    @examples = main.css('pre').map { |pre| pre.text.strip }
  end

  def extract_text_from_article(article)
    lines = []

    article.children.each do |node|
      case node.name
      when 'h2'
        next
      when 'p'
        lines << format_inline_elements(node)
        lines << ''
      when 'ul', 'ol'
        node.css('li').each do |li|
          lines << "- #{format_inline_elements(li)}"
        end
        lines << ''
      when 'pre'
        lines << ''
        lines << '```'
        lines << node.text.strip
        lines << '```'
        lines << ''
      when 'text'
        next
      end
    end

    lines.join("\n").strip
  end

  def format_inline_elements(node)
    html = node.inner_html
    html = html.gsub(%r{<em>(.*?)</em>}m, '*\1*')
    html = html.gsub(%r{<code>(.*?)</code>}m, '`\1`')
    Nokogiri::HTML(html).text.strip
  end

  def format_part(title, content)
    return nil unless content

    output = [title, '']

    content.lines.each do |line|
      stripped = line.rstrip
      output << if stripped.empty?
                  ''
                elsif stripped.length > 80
                  wrap_text(stripped, 80)
                else
                  stripped
                end
    end

    output.join("\n").strip
  end

  def wrap_text(text, width)
    words = text.split(' ')
    lines = []
    current_line = []
    current_length = 0

    words.each do |word|
      word_length = word.length

      if current_length + word_length + current_line.length > width
        lines << current_line.join(' ') unless current_line.empty?
        current_line = [word]
        current_length = word_length
      else
        current_line << word
        current_length += word_length
      end
    end

    lines << current_line.join(' ') unless current_line.empty?
    lines.join("\n")
  end
end
