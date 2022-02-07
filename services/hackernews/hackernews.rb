require_relative 'funcs.rb'

num_of_articles = ARGV[0]
if num_of_articles.numeric?() then
  parse_and_print(num_of_articles.to_i)
else
  parse_and_print(10)
end
