require_relative 'scraper'

class CarouselScraper < Scraper
attr_reader :artworks

  def initialize(params = {})
    super(params)
    if params.key?(:url)
      @carousel_element = css_scrape('div g-scrolling-carousel div>a')
      @artwork_array = Scraper.element_css_scrape(@carousel_element, 'a')
    end
  end

  def get_artworks_json
    @artworks = @artwork_array.map do |artwork|
      create_artwork(artwork)
    end
    {artworks: @artworks}
  end


  def extract_name_and_year(full_title)
    name_year_hash = {}
    match_data = full_title.match(name_year_regex_pattern)

    if !match_data.nil?
      name = match_data[:name].split(' (').first
      name_year_hash[:name] = name

      year = match_data[:year].chomp(')')
      name_year_hash[:year] = year
    end


    name_year_hash
  end

  private

  def create_artwork(artwork)
    artwork_hash = {}

    full_title = artwork.attribute('title').value
    name_year_hash = extract_name_and_year(full_title)

    if name_year_hash.empty?
      name = artwork.attribute('aria-label').value
    else
      name = name_year_hash[:name]
    end
    artwork_hash[:name] = name

    if name_year_hash.key?(:year)
      year = name_year_hash[:year]
      artwork_hash[:extensions] = [year]
    end

    link = "https://www.google.com#{artwork.attribute('href').value}"
    artwork_hash[:link] = link

    img = Scraper.element_css_scrape(artwork, 'img')
    img_id = img.attribute('id').value

    image = get_image_source(img_id)
    artwork_hash[:image] = image

    artwork_hash
  end

  def get_image_source(img_id)
    img_source = nil
    script_content = css_scrape('script').find { |script_tag| script_tag.content.include?('_setImagesSrc') }.content
    ar = script_content.split('(function(){')
    ar.each do |element|
      if img_source.nil? && element.include?(img_id)
        img_source = script_content.match(image_source_regexp)[:source]
      end
    end
    img_source
  end

  def name_year_regex_pattern
    # Looks for any characters, finalizing with a literal '(', and groups it
    name_pattern = '(?<name>[\S|\s]+\()'

    # Looks for any quantity of single characters, located between the other two specific Regex patterns, and groups it
    middle_portion_pattern = '(?<middle_portion>.*?)'

    # Looks for any positive number of digits, finalizing with a literal ')', and groups it
    year_pattern =  '(?<year>\d+\))'

    # Case insentive concatenation of patterns
    /#{name_pattern}#{middle_portion_pattern}#{year_pattern}/i
  end

  def image_source_regexp
    # Inside each function(), looks for the definition of the 's' variable, and stores in the 'source' group
    # the value between the single quotes
    pattern = "var s='(?<source>[^']*)'"
    /#{pattern}/
  end
end
