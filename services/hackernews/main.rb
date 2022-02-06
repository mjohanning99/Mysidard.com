require 'uri'
require 'net/http'
require 'json'
require 'date'

puts "=> /index.bliz 🏠Back Home"

puts "# Hacker News Proxy 📰"
puts "This is a small Hacker News Proxy written in Ruby. It is still a work in progress, but it already allows for the fetching of articles from the main page and reading of their comments."
puts ""

class String
  def numeric?
    !self.match(/[^0-9]/)
  end
end

def get_ids(url)
  uri = URI(url)
  res = Net::HTTP.get_response(uri)
  ids = Array.new

  if res.is_a?(Net::HTTPSuccess) then
    res.body.gsub("[", "").gsub("]", "").split(",").each do |item|
      ids << item
    end
  end
  return ids
end

def get_stories(num)
  counter = 0
  json = Array.new

  get_ids('https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty').each do |story|
    story = story.gsub(" ", "")
    uri = URI("https://hacker-news.firebaseio.com/v0/item/#{story}.json?print=pretty)")
    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess) then
      json << res.body
      counter += 1
      break if counter == num
    end

  end
  return json
end

def parse_and_print(num)
  puts "#{num} article(s) have been loaded."
  get_stories(num).each do |story|
    puts "## " + JSON.parse(story)["title"] + " (⇧ " + JSON.parse(story)["score"].to_s + ")"

    begin
      puts "=> " + JSON.parse(story)["url"]
    rescue TypeError
      puts ""
    end

    puts "✍️ By: " + JSON.parse(story)["by"]
    puts DateTime.strptime(JSON.parse(story)["time"].to_s, "%s").strftime("🕰 Published on %d/%m/%Y at %H:%M") 
    puts "=> comments.bliz?#{JSON.parse(story)['id']}" + " 📝 Comments (#{JSON.parse(story)['descendants']})"

    puts ""
  end
end

