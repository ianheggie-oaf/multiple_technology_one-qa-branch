#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << "./lib"

require "technology_one_scraper"

# Main Scraper class
class Scraper
  AUTHORITIES = TechnologyOneScraper::AUTHORITIES

  def self.scrape(authorities)
    exceptions = {}
    authorities.each do |authority_label|
      puts "\nCollecting feed data for #{authority_label}..."

      begin
        TechnologyOneScraper.scrape(authority_label) do |record|
          record["authority_label"] = authority_label.to_s
          TechnologyOneScraper.log(record)
          ScraperWiki.save_sqlite(%w[authority_label council_reference], record)
        end
      rescue StandardError => e
        warn "#{authority_label}: ERROR: #{e}"
        warn e.backtrace
        exceptions[authority_label] = e
      end
    end
    exceptions
  end

  def self.selected_authorities
    AUTHORITIES.keys
  end

  def self.run(authorities)
    puts "Scraping authorities: #{authorities.join(', ')}"
    exceptions = scrape(authorities)

    unless exceptions.empty?
      puts "\n***************************************************"
      puts "Now retrying authorities which earlier had failures"
      puts "***************************************************"

      exceptions = scrape(exceptions.keys)
    end

    return if exceptions.empty?

    raise "There were errors with the following authorities: #{exceptions.keys}. " \
            "See earlier output for details"
  end
end

Scraper.run(Scraper.selected_authorities) if __FILE__ == $PROGRAM_NAME
