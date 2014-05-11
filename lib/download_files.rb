require_relative "download_files/version"

require 'mechanize'

class Mechanize
  def self.start
    yield(new)
  end

  def self.go(page_address, ssl_verify)
    start do |agent|
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE unless ssl_verify
      agent.get(page_address) do |page|
        yield agent, page
      end
    end
  end
end

module DownloadFiles
  def self.download_files(
    page_address,
    pattern,
    dir,
    ssl_verify,
    is_verbose,
    logger
  )
    logger.debug(
      "DownloadFiles.download_files: " +
      {
        page_address: page_address,
        pattern: pattern,
        dir: dir,
        ssl_verify: ssl_verify,
        is_verbose: is_verbose,
        logger: logger
      }.inspect
    )

    abs_dir = File.absolute_path(dir)

    logger.info(
      "Downloading files from \"#{page_address}\" to \"#{abs_dir}\" that match /#{pattern}/ " +
      (if ssl_verify then 'requiring' else 'without requiring' end + ' SSL verification') +
      '...'
    )

    Mechanize.go(page_address, ssl_verify) do |agent, page|
      logger.debug page.inspect

      if is_verbose
        logger.info "On #{page.uri}"
      end

      agent.pluggable_parser.default = Mechanize::Download

      page.links.each do |link|
        if is_verbose
          logger.info "Checking link #{link.href}"
        end

        next unless link.href && link.href.match(pattern)

        full_file_name = File.expand_path(File.basename(link.href), abs_dir)

        if is_verbose
          logger.info "Downloading #{link.click.uri} to #{full_file_name}"
        end

        agent.get(link.click.uri).save(full_file_name)
      end
    end
  end
end