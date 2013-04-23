require_relative "download_files/version"

require 'mechanize'
require 'nullobject'

class Mechanize
  def self.start
    yield(new)
  end

  def self.go(page_address)
    start do |agent|
      agent.get(page_address) do |page|
        yield agent, page
      end
    end
  end
end

module DownloadFiles
  def self.download_files(page_address, pattern, dir=FileUtils.pwd, logger=Null::Object.instance)
    logger.debug "DownloadFiles.download_files: " + {page_address: page_address, pattern: pattern, dir: dir, logger: logger}.inspect

    abs_dir = File.expand_path(dir, FileUtils.pwd)

    Mechanize.go(page_address) do |agent, page|
      logger.debug page.inspect
      logger.info "On #{page.uri}"

      agent.pluggable_parser.default = Mechanize::Download

      page.links.each do |link|
        logger.debug "Checking link #{link.href}"

        next unless link.href && link.href.match(pattern)

        full_file_name = File.expand_path(File.basename(link.href), abs_dir)
        logger.info "Downloading #{link.click.uri} to #{full_file_name}"

        agent.get(link.click.uri).save(full_file_name)
      end
    end
  end
end