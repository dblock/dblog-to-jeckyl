require 'rubygems'
require 'bundler'

Bundler.setup :default, :development

require 'yaml'
require 'active_record'
require 'reverse_markdown'
require 'csv'

dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig["development"])

Dir['models/**/*.rb'].each do |f|
  require File.expand_path(f)
end

puts "Reading #{Post.count} post(s) ..."
CSV.open("discus.csv", "w") do |csv|
  Post.order('created ASC').each do |post|
    puts "#{post.Slug}: #{post.Title}"
    filename = "#{post.Created.strftime('%F').gsub('-','/')}/#{post.Slug}.html"
    csv << ["http://code.dblock.org/ShowPost.aspx?id=#{post.Post_Id}", "http://code.dblock.org/#{filename}"]
  end
end
