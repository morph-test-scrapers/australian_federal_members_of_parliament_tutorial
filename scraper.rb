# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new

["1", "2", "3"].each do |page_number|
  puts "Getting page #{page_number}"
  page = agent.get("http://www.aph.gov.au/Senators_and_Members/Parliamentarian_Search_Results?q=&mem=1&sen=1&par=-1&gen=0&ps=100&st=1&page=" + page_number)

  people = page.at("ul.search-filter-results").search("li")

  people.each do |person|
    name = person.at(".title").text
    image_url = person.at("img").attr("src")
    party = person.search("dd")[-2].text

    puts "Saving person: #{name}"
    ScraperWiki.save_sqlite([:name], {name: name, image_url: image_url, party: party})
  end
end

# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
