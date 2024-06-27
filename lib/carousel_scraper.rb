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

    google_link = "https://www.google.com#{test_artwork.attribute('href').value}"

    full_title = test_artwork.attribute('title').value
    title_year_hash = extract_title_and_year(full_title)

    img = Scraper.element_css_scrape(test_artwork, 'img')
    img_id = img.attribute('id').value

    image = get_image_source(img_id)
  end


  def extract_title_and_year(full_title)
    match_data = full_title.match(title_year_regex_pattern)

    title = match_data[:title].split(' (').first
    year = match_data[:year].chomp(')').to_i

    {
      title:,
      year:
    }
  end

  private

  def get_image_source(img_id)
    script_content = css_scrape('script').find { |script_tag| script_tag.content.include?('_setImagesSrc') }.content
    ar = script_content.split('(function(){')
    ar.each do |element|
      if element.include?(img_id)
        return script_content.match(image_source_regexp)[:source]
      end
    end
  end

  def title_year_regex_pattern
    # Looks for any positive number of either an alphabet letter or whitespace, finalizing with a literal '(', and groups it
    title_pattern = '(?<title>[a-z|\s]+\()'

    # Looks for any quantity of single characters, located between the other two specific Regex patterns, and groups it
    middle_portion_pattern = '(?<middle_portion>.*?)'

    # Looks for any positive number of digits, finalizing with a literal ')', and groups it
    year_pattern =  '(?<year>\d+\))'

    # Case insentive concatenation of patterns
    /#{title_pattern}#{middle_portion_pattern}#{year_pattern}/i
  end

  def image_source_regexp
    # Inside each function(), looks for the definition of the 's' variable, and stores in the 'source' group
    # the value between the single quotes
    pattern = "var s='(?<source>[^']*)'"
    /#{pattern}/
  end
end
