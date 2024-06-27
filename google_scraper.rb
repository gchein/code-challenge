require 'bundler'
Bundler.require(:default)

def get_parsed_html(url)
  html_file = URI.open(url).read
  Nokogiri::HTML.parse(html_file)
end

def scrape_element(html_element, selector)
  html_element.search(@selector)
end
