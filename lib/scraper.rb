require 'bundler'
Bundler.require(:default)

# Each instance of Scraper will represent a separate HTML page, which has a 'scrape_element'
# method, through which the user can pass CSS selectors to scrape the page
class Scraper
  def initialize(params = {})
    @url = params[:url]
    @parsed_html = get_parsed_html
  end

  # Method for scraping the HTML page, given a CSS selector
  def scrape_element(selector)
    @parsed_html.search(selector)
  end

  private

  # Retrieves the parsed HTML based on the URL given, utilizing Nokogiri
  def get_parsed_html
    html_file = URI.open(@url).read
    Nokogiri::HTML.parse(html_file)
  end
end
