require 'rubygems'
require 'bundler'

Bundler.setup :default, :development

require 'yaml'
require 'active_record'
require 'reverse_markdown'

dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["development"])

Dir['models/**/*.rb'].each do |f|
  require File.expand_path(f)
end

root = '/Users/dblock/source/code.dblock.org/dblock'
posts_path = "#{root}/_posts"

puts "Reading #{Post.count} post(s) ..."
Post.order('created ASC').each do |post|
  puts "#{post.Slug}: #{post.Title}"
  post_markdown_filename = "#{post.Created.strftime('%F')}-#{post.Slug}"
  year_posts_path = "#{posts_path}/#{post.Created.strftime('%Y')}"
  filename = "#{year_posts_path}/#{post_markdown_filename}.markdown"
  next unless File.exists?(filename)
  content = File.read(filename)
  content.gsub! 'comments: true', "comments: true\ndblog.post_id: #{post.Post_Id}"
  File.open filename, "wt" do |file|
    file.write content
  end
end
