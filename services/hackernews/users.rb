require 'uri'
require 'net/http'
require 'json'
require 'date'    
require 'nokogiri'
require 'reverse_markdown'
require_relative 'funcs.rb'

puts "=> index.bliz 📰 Back To Overview"

def get_user(id)
  json = String.new

  uri = URI("https://hacker-news.firebaseio.com/v0/user/#{id}.json?print=pretty")
  res = Net::HTTP.get_response(uri)

  json << res.body if res.is_a?(Net::HTTPSuccess)
  return json
end

def get_user_posts(num, user)
  counter = 0
  json = Array.new

  JSON.parse(user)["submitted"].each do |post|
    json << post

    counter += 1
    break if counter == num
  end

  return json
end

def display_user_posts(num, user)   
  get_user_posts(num, user).each do |post|
    uri = URI("https://hacker-news.firebaseio.com/v0/item/#{post}.json?print=pretty)")
    res = Net::HTTP.get_response(uri)
    user_content = res.body
    content_type = JSON.parse(user_content)["type"]

    if content_type == "story" then
      puts DateTime.strptime(JSON.parse(user_content)["time"].to_s, "%s").strftime("### Post from %d/%m/%Y at %H:%M")
      puts "=> comments.bliz?#{post}" + " 📜 #{JSON.parse(user_content)['title']}"

    elsif content_type == "comment" && JSON.parse(user_content)["text"] != nil then
      puts DateTime.strptime(JSON.parse(user_content)["time"].to_s, "%s").strftime("### Comment from %d/%m/%Y at %H:%M")
      puts user_content.to_gemini("text")
    end

    puts ""
  end
end

def display_user(id, num_posts)
  user = get_user(id)

  puts "# Viewing user: #{JSON.parse(user)['id']}" + " (⇧#{JSON.parse(user)['karma']})" 
  puts DateTime.strptime(JSON.parse(user)["created"].to_s, "%s").strftime("This user account was created on %d/%m/%Y at %H:%M")

  puts "## About"
  unless JSON.parse(user)["about"] == nil then 
    puts user.to_gemini("about")
  else 
    puts "#{id} does not appear to have anything in their about section." 
  end

  puts "## #{num_posts} Latest Posts and Comments"
  display_user_posts(10, user)
end

display_user(ARGV[0], 10)