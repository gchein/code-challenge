require_relative 'scraper'

class CarouselScraper < Scraper
  def initialize(params = {})
    super(params)
    if params.key?(:url)
      @carousel_element = css_scrape('div g-scrolling-carousel')
      @artwork_array = Scraper.element_css_scrape(@carousel_element, 'a')
    end
  end

  def get_artworks_json
    test_artwork = @artwork_array.first

    google_link = "google.com#{test_artwork.attribute('href').value}"

    full_title = test_artwork.attribute('title').value
    title_year_hash = extract_title_and_year(full_title)


  end


  def extract_title_and_year(full_title)
    match_data = full_title.match(regex_pattern)

    title = match_data[:title].split(' (').first
    year = match_data[:year].chomp(')').to_i

    {
      title:,
      year:
    }
  end

  private

  def regex_pattern
    # Looks for any positive number of either an alphabet letter or whitespace, finalizing with a literal '(', and groups it
    title_pattern = '(?<title>[a-z|\s]+\()'

    # Looks for any quantity of single characters, located between the other two specific Regex patterns, and groups it
    middle_portion_pattern = '(?<middle_portion>.*?)'

    # Looks for any positive number of digits, finalizing with a literal ')', and groups it
    year_pattern =  '(?<year>\d+\))'

    # Case insentive concatenation of patterns
    /#{title_pattern}#{middle_portion_pattern}#{year_pattern}/i
  end
end
