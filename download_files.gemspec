# -*- encoding: utf-8 -*-
require File.expand_path('../lib/download_files/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dustin Morrill"]
  gem.email         = ["dmorrill10@gmail.com"]
  gem.description   = %q{Download all files at a particular URL that match a certain pattern.}
  gem.summary       = %q{Download all files at a particular URL that match a certain pattern.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "download_files"
  gem.require_paths = ["lib"]
  gem.version       = DownloadFiles::VERSION

  gem.add_development_dependency('rake', '~> 0.9.2')

  gem.add_dependency('methadone', '~> 1.4.0')
  gem.add_dependency('mechanize', '~> 2.7.3')
end
