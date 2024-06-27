require_relative 'lib/scraper'

url = 'files/van-gogh-paintings.html'
searchpage = Scraper.new(url:)

carousel_element = searchpage.css_scrape("div g-scrolling-carousel")
artwork_array = Scraper.element_css_scrape(carousel_element, 'a')

test_artwork = artwork_array.first

google_link = "google.com#{test_artwork.attribute('href').value}"
p google_link

full_title = test_artwork.attribute('title').value

# Looks for any positive number of either an alphabet letter or whitespace, finalizing with a literal '(', and groups it
title_pattern = '(?<title>[a-z|\s]+\()'

# Looks for any quantity of single characters, located between the other two specific Regex patterns, and groups it
middle_portion_pattern = '(?<middle_portion>.*?)'

# Looks for any positive number of digits, finalizing with a literal ')', and groups it
year_pattern =  '(?<year>\d+\))'

# Case insentive concatenation of patterns
full_pattern = /#{title_pattern}#{middle_portion_pattern}#{year_pattern}/i
match_data = full_title.match(full_pattern)

title = match_data[:title].split(' (').first
p title
year = match_data[:year].chomp(')').to_i
p year
