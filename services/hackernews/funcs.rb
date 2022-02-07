class String
  def numeric?
    !self.match(/[^0-9]/)
  end

  def to_gemini(json_class)
    html = Nokogiri::HTML(JSON.parse(self)["#{json_class}"]).serialize
    markdown = ReverseMarkdown.convert(html)
    parsed = String.new

    markdown.each_line do |line|
      if line =~ /^\\/ then
        line.slice!(0)
        parsed << line
      else
        parsed << line
      end
    end

    return parsed
  end
end