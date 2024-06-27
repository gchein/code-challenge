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

RSpec.describe 'Regex Validation' do
  let(:regex_tests) do
    {
      test_strings:
      [
        'Guernica (Pablo Picasso, 1937)',
        'The Starry Night (1889)',
        'Vitruvian Man (by Leonardo da Vinci, circa 1490)'
      ],
      correct_titles:
      [
        'Guernica',
        'The Starry Night',
        'Vitruvian Man'
      ],
      correct_years:
      [
        1937,
        1889,
        1490
      ]
    }

  end

  # Looks for any positive number of either an alphabet letter or whitespace, finalizing with a literal '(', and groups it
  title_pattern = '(?<title>[a-z|\s]+\()'

  # Looks for any quantity of single characters, located between the other two specific Regex patterns, and groups it
  middle_portion_pattern = '(?<middle_portion>.*?)'

  # Looks for any positive number of digits, finalizing with a literal ')', and groups it
  year_pattern =  '(?<year>\d+\))'

  # Case insentive concatenation of patterns
  full_pattern = /#{title_pattern}#{middle_portion_pattern}#{year_pattern}/i

  it 'should have valid Regex to extract data' do
    regex_tests[:test_strings].each_with_index do |string, index|
      match_data = string.match(full_pattern)

      title = match_data[:title].split(' (').first
      expect(title).to eq(regex_tests[:correct_titles][index])

      year = match_data[:year].chomp(')').to_i
      expect(year).to eq(regex_tests[:correct_years][index])
    end

  end
end
