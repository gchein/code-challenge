require 'scraper'
require 'pry-byebug'

RSpec.describe Scraper do
  let(:url) { 'files/van-gogh-paintings.html' }
  let(:parsed_html) { Scraper.new(url:) }

  it 'should not return nil for parsing an HTML file' do
    expect(parsed_html).not_to be_nil
  end

  it 'should allow for scraping elements with valid CSS Selectors' do
    scraped_elements = parsed_html.css_scrape('div')
    expect(scraped_elements.length).to be > 0
  end

  it 'should be empty given invalid CSS selectors' do
    invalid_id_element = parsed_html.css_scrape('#test_nonexistent_id')
    expect(invalid_id_element.empty?).to be true
  end

  it 'should be a link with a valid Carousel for inspecting' do
    carousel_element = parsed_html.css_scrape('div g-scrolling-carousel')
    expect(carousel_element.length).to be > 0
  end

  it 'should be able to scrape given HTML elements' do
    carousel_element = parsed_html.css_scrape('div g-scrolling-carousel')
    anchor_tags = Scraper.element_css_scrape(carousel_element, 'a')
    expect(anchor_tags.length).to be > 0
  end
end
