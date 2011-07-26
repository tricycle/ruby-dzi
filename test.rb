require File.join(File.dirname(__FILE__), 'lib/ruby_dzi')

dzi = RubyDzi.new('coffee.jpg')
puts dzi.image_path

dzi.generate!('coffee')

dzi_web = RubyDzi.new('http://farm5.static.flickr.com/4034/4717106041_c116b92c81_b_d.jpg')
dzi.generate!('sunset')
