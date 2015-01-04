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

references = Hash[Reference.all.map do |ref|
  [ref.Word, "[#{ref.Result}](#{ref.Url})"]
end]

puts "Loaded #{references.count} reference(s)."

root = '/Users/dblock/source/code.dblock.org/dblock'
posts_path = "#{root}/_posts"
images_path = "#{root}/images/posts"

puts "Reading #{Post.count} post(s) ..."
Post.order('created ASC').each do |post|
  puts "#{post.Slug}: #{post.Title} (#{post.topics.join(', ')})"

  post_markdown_filename = "#{post.Created.strftime('%F')}-#{post.Slug}"

  # html to markdown
  content = ReverseMarkdown.convert(post.Body, github_flavored: true)
  # references
  content.gsub! /\w+:\w+/ do |match|
    references[match] || match
  end
  # code blocks
  content.gsub! /\s*\[code\]\s*/, "\n\n"
  content.gsub! /\s*\[\/code\]\s*/, "\n\n"
  # images
  content.gsub! /(\(.*\/ShowPicture\.aspx\?id=)(\d*).*\)/ do |match|
    id = Regexp.last_match.captures[1]
    image = Image.find(id.to_i)
    post_images_path = "#{images_path}/#{post.Created.strftime('%Y')}/#{post_markdown_filename}"
    FileUtils.mkdir_p post_images_path unless Dir.exist?(post_images_path)
    File.open "#{post_images_path}/#{image.Name.downcase}", "wb" do |file|
      file.write image.Data
    end
    "({{ site.url }}/images/posts/#{post.Created.strftime('%Y')}/#{post_markdown_filename}/#{image.Name.gsub('[', '%5B').gsub(']', '%5D').downcase})"
  end
  # cuts
  content.gsub! /\[cut\].*\[\/cut\]/, '<!-- more -->'
  # font size=1
  content.gsub! /<font size="1">(.*)<\/font>/ do |match|
    Regexp.last_match.captures[0]
  end

  year_posts_path = "#{posts_path}/#{post.Created.strftime('%Y')}"
  FileUtils.mkdir_p year_posts_path unless Dir.exist?(year_posts_path)
  File.open "#{year_posts_path}/#{post_markdown_filename}.markdown", "w" do |file|
    file.write <<-EOS
---
layout: post
title: "#{post.Title}"
redirect_from: "/#{post.Slug.length == 0 ? post.Post_Id : post.Slug}"
date: #{post.Created.strftime('%F %T')}
tags: [#{post.topics.join(', ')}]
---
#{content}
    EOS
  end
end
