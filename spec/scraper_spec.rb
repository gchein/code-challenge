require 'scraper'

RSpec.describe Scraper do
  let(:url) { 'files/van-gogh-paintings.html' }
  let(:parsed_html) { Scraper.new(url:) }

  it 'Should not return nil for parsing an HTML file' do
    expect(parsed_html).not_to be_nil
  end

  it 'Should allow for scraping elements with valid CSS Selectors' do
    scraped_elements = parsed_html.scrape_element("div")
    expect(scraped_elements.length).to be > 0
  end

end
