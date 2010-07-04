require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('ruby-dzi', '0.1.1') do |p|
  p.description    = "Ruby Dzi slices images into several tiles and creates dzi descriptor file."
  p.url            = "http://github.com/netxph/ruby-dzi"
  p.author         = "Marc Vitalis"
  p.email          = "marc.vitalis@live.com"
  p.ignore_pattern = ["*.jpg", "*_files/**/**", "test.rb", "*.dzi", "pkg"]
  p.development_dependencies = ["rmagick"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

