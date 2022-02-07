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

def display_user(id)
  user = get_user(id)

  puts "# Viewing user: #{JSON.parse(user)['id']}" + " (⇧#{JSON.parse(user)['karma']})" 
  puts DateTime.strptime(JSON.parse(user)["created"].to_s, "%s").strftime("This user account was created on %d/%m/%Y at %H:%M")

  puts "## About"
  if JSON.parse(user)["about"] != nil then 
    puts JSON.parse(user)["about"] 
  else 
    puts "#{id} does not appear to have anything in their about section." 
  end

  puts 
end

display_user(ARGV[0])