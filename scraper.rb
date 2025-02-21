#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH << "./lib"

require "scraper_utils"
require "technology_one_scraper"

# Main Scraper class
class Scraper
  AUTHORITIES = TechnologyOneScraper::AUTHORITIES

  def self.scrape(authorities, attempt)
    results = {}
    authorities.each do |authority_label|
      these_results = results[authority_label] = {}
      begin
        records_scraped = 0
        unprocessable_records = 0
        # Allow 5 + 10% unprocessable records
        too_many_unprocessable = -5.0
        use_proxy = AUTHORITIES[authority_label][:australian_proxy] && ScraperUtils.australian_proxy
        next if attempt > 2 && !use_proxy

        puts "",
             "Collecting feed data for #{authority_label}, attempt: #{attempt}" \
               "#{use_proxy ? ' (via proxy)' : ''} ..."
        # Change scrape to accept a use_proxy flag and return an unprocessable flag
        # it should rescue ScraperUtils::UnprocessableRecord thrown deeper in the scraping code and
        # set unprocessable
        TechnologyOneScraper.scrape(use_proxy, authority_label) do |record, unprocessable|
          unless unprocessable
            begin
              record["authority_label"] = authority_label.to_s
              ScraperUtils::DbUtils.save_record(record)
            rescue ScraperUtils::UnprocessableRecord => e
              # validation error
              unprocessable = true
              these_results[:error] = e
            end
          end
          if unprocessable
            unprocessable_records += 1
            these_results[:unprocessable_records] = unprocessable_records
            too_many_unprocessable += 1
            raise "Too many unprocessable records" if too_many_unprocessable.positive?
          else
            records_scraped += 1
            these_results[:records_scraped] = records_scraped
            too_many_unprocessable -= 0.1
          end
        end
      rescue StandardError => e
        warn "#{authority_label}: ERROR: #{e}"
        warn e.backtrace || "No backtrace available"
        these_results[:error] = e
      end
    end
    results
  end

  def self.selected_authorities
    ScraperUtils::AuthorityUtils.selected_authorities(AUTHORITIES.keys)
  end

  def self.run(authorities)
    puts "Scraping authorities: #{authorities.join(', ')}"
    start_time = Time.now
    results = scrape(authorities, 1)
    ScraperUtils::LogUtils.log_scraping_run(
      start_time,
      1,
      authorities,
      results
    )

    retry_errors = results.select do |_auth, result|
      result[:error] && !result[:error].is_a?(ScraperUtils::UnprocessableRecord)
    end.keys

    unless retry_errors.empty?
      puts "",
           "***************************************************"
      puts "Now retrying authorities which earlier had failures"
      puts retry_errors.join(", ").to_s
      puts "***************************************************"

      start_retry = Time.now
      retry_results = scrape(retry_errors, 2)
      ScraperUtils::LogUtils.log_scraping_run(
        start_retry,
        2,
        retry_errors,
        retry_results
      )

      retry_results.each do |auth, result|
        unless result[:error] && !result[:error].is_a?(ScraperUtils::UnprocessableRecord)
          results[auth] = result
        end
      end.keys
      retry_no_proxy = retry_results.select do |_auth, result|
        result[:used_proxy] && result[:error] &&
          !result[:error].is_a?(ScraperUtils::UnprocessableRecord)
      end.keys

      unless retry_no_proxy.empty?
        puts "",
             "*****************************************************************"
        puts "Now retrying authorities which earlier had failures without proxy"
        puts retry_no_proxy.join(", ").to_s
        puts "*****************************************************************"

        start_retry = Time.now
        second_retry_results = scrape(retry_no_proxy, 3)
        ScraperUtils::LogUtils.log_scraping_run(
          start_retry,
          3,
          retry_no_proxy,
          second_retry_results
        )
        second_retry_results.each do |auth, result|
          unless result[:error] && !result[:error].is_a?(ScraperUtils::UnprocessableRecord)
            results[auth] = result
          end
        end.keys
      end
    end

    # Report on results, raising errors for unexpected conditions
    ScraperUtils::LogUtils.report_on_results(authorities, results)
  end
end

if __FILE__ == $PROGRAM_NAME
  # Default to list of authorities we can't or won't fix in code, explain why
  ENV["MORPH_EXPECT_BAD"] ||= "wagga"
  Scraper.run(Scraper.selected_authorities)
end

