require 'carousel_scraper'

RSpec.describe CarouselScraper do
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

  let(:url) { 'files/van-gogh-paintings.html' }
  let(:parsed_html) { CarouselScraper.new(url:) }

  it 'should have valid Regex to extract data' do
    regex_tests[:test_strings].each_with_index do |string, index|
      title_year_hash = parsed_html.extract_title_and_year(string)

      title = title_year_hash[:title]
      expect(title).to eq(regex_tests[:correct_titles][index])

      year = title_year_hash[:year]
      expect(year).to eq(regex_tests[:correct_years][index])
    end

  end
end
