require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'nokogiri'
require 'reverse_markdown'
require_relative 'funcs.rb'

puts "=> index.bliz 📰 Back To Overview"

def get_article(id)
  json = String.new

  uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json?print=pretty)")
  res = Net::HTTP.get_response(uri)

  json << res.body if res.is_a?(Net::HTTPSuccess)
  puts "# Comments for: #{JSON.parse(json)['title']}\n" 

  puts "=> #{JSON.parse(json)['url']} 🌍 Article Link"
  puts ""

  return json
end

def get_comment_ids(num, article)
  counter = 0
  comment_ids = Array.new

  JSON.parse(article)["kids"].each do |comment|
    comment_ids << comment
    counter += 1
    break if counter == num
  end

  return comment_ids
end

def display_comments(num, article_id)
  json = Array.new

  get_comment_ids(num, get_article(article_id)).each do |id|
    uri = URI("https://hacker-news.firebaseio.com/v0/item/#{id}.json?print=pretty)")
    res = Net::HTTP.get_response(uri)

    json << res.body if res.is_a?(Net::HTTPSuccess)
  end

  json.each do |comment|
    puts "## Comment by " + JSON.parse(comment)["by"]
    puts "=> users.bliz?#{JSON.parse(comment)['by']}" + " 📡 Display User Page"

    puts comment.to_gemini("text")

    puts DateTime.strptime(JSON.parse(comment)["time"].to_s, "%s").strftime("🕰 Published on %d/%m/%Y at %H:%M")

    puts ""
  end
end

display_comments(10, ARGV[0])
