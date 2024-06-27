require_relative 'lib/carousel_scraper'

url = 'files/van-gogh-paintings.html'
searchpage = CarouselScraper.new(url:)

searchpage.get_artworks_json
