# frozen_string_literal: true

require 'httparty'
require 'date'
require_relative 'cache'

class Client
  include HTTParty
  base_uri 'https://adventofcode.com'

  def initialize(cache_dir: '.cache')
    @session_token = ENV['SESSION_TOKEN']
    raise 'session token not set' unless @session_token

    @cache = Cache.new(cache_dir)
  end

  def fetch_puzzle(year = Date.today.year, day = Date.today.day, force_refresh: false)
    html = fetch_html(year, day, force_refresh)
    cache_parsed_content(year, day, html)
    html
  end

  def fetch_input(year = Date.today.year, day = Date.today.day)
    cached = @cache.read_input(year, day)
    return cached if cached

    response = self.class.get("/#{year}/day/#{day}/input", headers: headers)
    body = handle_response(response, "input for #{year} day #{day}")

    @cache.write_input(year, day, body)
    body
  end

  def submit_answer(year, day, level, answer)
    response = self.class.post(
      "/#{year}/day/#{day}/answer",
      body: { level: level, answer: answer },
      headers: headers
    )
    body = handle_response(response, "submission for #{year} day #{day} level #{level}")

    @cache.invalidate_html(year, day)

    body
  end

  private

  def headers
    {
      'Cookie' => "session=#{@session_token}",
      'User-Agent' => 'ruby_aoc_client'
    }
  end

  def fetch_html(year, day, force_refresh)
    cached = @cache.read_html(year, day)
    return cached if !force_refresh && cached

    response = self.class.get("/#{year}/day/#{day}", headers: headers)
    body = handle_response(response, "puzzle for #{year} day #{day}")

    @cache.write_html(year, day, body)
    body
  end

  def cache_parsed_content(year, day, html)
    require_relative 'parser'
    puzzle = ::Parser.new(html)

    @cache.write_part(year, day, 1, puzzle.formatted_part1) if puzzle.formatted_part1
    @cache.write_part(year, day, 2, puzzle.formatted_part2) if puzzle.formatted_part2
    @cache.write_examples(year, day, puzzle.examples)
  end

  def handle_response(response, context)
    case response.code
    when 200
      response.body
    when 400
      raise "bad request for #{context}"
    when 404
      raise "not found for #{context}"
    when 500..599
      raise "server error for #{context}"
    else
      raise "unexpected response for #{context}"
    end
  end
end
