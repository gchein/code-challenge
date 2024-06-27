require 'carousel_scraper'

RSpec.describe CarouselScraper do
  describe 'Valid Carousel Scraper' do
    let(:url) { 'files/van-gogh-paintings.html' }
    let(:carousel_html) { CarouselScraper.new(url:) }

    it 'should have a valid carousel element' do
      scraped_elements = carousel_html.css_scrape('div g-scrolling-carousel')
      expect(scraped_elements.length).to be > 0
    end
  end

  describe 'Regex tests' do
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

    let(:blank_scraper) { CarouselScraper.new(allow_nil_url: true) }

    it 'should have valid Regex to extract data' do
      regex_tests[:test_strings].each_with_index do |string, index|
        title_year_hash = blank_scraper.extract_title_and_year(string)

        title = title_year_hash[:title]
        expect(title).to eq(regex_tests[:correct_titles][index])

        year = title_year_hash[:year]
        expect(year).to eq(regex_tests[:correct_years][index])
      end

    end
  end
end
