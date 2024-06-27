require 'bundler'
Bundler.require(:default)

# Each instance of Scraper will represent a separate HTML page, which has a 'scrape_element'
# method, through which the user can pass CSS selectors to scrape the page
class Scraper

  attr_reader :url

  def initialize(params = {})
    @url = params[:url] if params.key?(:url)
    @parsed_html = get_parsed_html if params.key?(:url) || !params[:allow_nil_url]
  end

  # Instance Method for scraping the HTML page, given a CSS selector
  def css_scrape(selector)
    @parsed_html.css(selector)
  end

  # Class Method for scraping a specific element passed as argument, given a CSS selector
  def self.element_css_scrape(html_element, selector)
    html_element.css(selector)
  end

  private

  # Retrieves the parsed HTML based on the URL given, utilizing Nokogiri
  def get_parsed_html
    html_file = URI.open(@url).read
    Nokolexbor::HTML(html_file)
  end
end
