require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'nokogiri'

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

    if JSON.parse(res.body)["type"] == "story" then
      puts "=> comments.bliz?#{post}" + " 📜 #{JSON.parse(res.body)['title']}"
    end
  end
end

def display_user(id, num_posts)
  user = get_user(id)

  puts "# Viewing user: #{JSON.parse(user)['id']}" + " (⇧#{JSON.parse(user)['karma']})" 
  puts DateTime.strptime(JSON.parse(user)["created"].to_s, "%s").strftime("This user account was created on %d/%m/%Y at %H:%M")

  puts "## About"
  if JSON.parse(user)["about"] != nil then 
    puts Nokogiri::HTML(JSON.parse(user)["about"]).text
  else 
    puts "#{id} does not appear to have anything in their about section." 
  end

  puts "## Created Posts (displaying the #{num_posts} latest posts)"
  display_user_posts(10, user)
end

display_user(ARGV[0], 10)