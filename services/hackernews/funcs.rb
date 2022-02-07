class String
  def numeric?
    !self.match(/[^0-9]/)
  end

  def to_gemini(json_class)
    html = Nokogiri::HTML(JSON.parse(self)["#{json_class}"]).serialize
    markdown = ReverseMarkdown.convert(html)

    if markdown =~ /^\\/ then
      markdown.slice!(0)
    end

    return markdown
  end
end