require 'rubygems'
require 'bundler'

Bundler.setup :default, :development

root = '/Users/dblock/source/code.dblock.org/dblock'
images_path = "#{root}/images/posts"

Dir["#{images_path}/**/*"].each do |f|
  original_filename = File.expand_path(f)
  new_filename = original_filename.gsub(/[\[\]]/, '_').gsub('_.', '.')
  next unless original_filename != new_filename
  puts new_filename
  File.rename original_filename, new_filename
end

