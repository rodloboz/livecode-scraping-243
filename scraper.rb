# Fetch the top 5 movies
# Select td titleColumn
# Read a href attribut
# Strip away query string from url
# Return an array with 5 urls
require "nokogiri"
require "open-uri"
require "byebug"

BASE_URL = "http://www.imdb.com"

def fetch_movie_urls
  # movies = []
  url = "#{BASE_URL}/chart/top"
  html_file = open(url, "Accept-Language" => "en-US").read
  html_doc = Nokogiri::HTML(html_file)
  html_doc.search(".titleColumn a").take(5).map do |link|
    BASE_URL + link["href"]
  end
  # movies
end

# Fetch info on each of these movies (url)
# Select h1 (name and year)
# Select summary_text (storyline)
# Select credit_summary_item (Director, cast)
# return hash of movie


# {
#   cast: [ "Christian Bale", "Heath Ledger", "Aaron Eckhart" ],
#   director: "Christopher Nolan",
#   storyline: "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham. The Dark Knight must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
#   title: "The Dark Knight",
#   year: 2008
# }

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en-US").read
  html_doc = Nokogiri::HTML(html_file)
  pattern = /(?<title>.*)[[:space:]]\((?<year>\d{4})\)/

  match_data = html_doc.search("h1").text.match(pattern)
  title = match_data[:title]
  year = match_data[:year]
  storyline = html_doc.search('.summary_text').text.strip
  director = html_doc.search('.credit_summary_item a').first.text

  cast = []
  html_doc.search('.credit_summary_item').last.search('a').each do |link|
    cast << link.text
  end
  cast.pop

  {
    cast: cast,
    title: title,
    director: director,
    storyline: storyline,
    year: year.to_i
  }
end

the_dark_knight_url = "http://www.imdb.com/title/tt0468569/"
p scrape_movie(the_dark_knight_url)

