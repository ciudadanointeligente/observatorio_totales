require 'scraperwiki'
require 'nokogiri'

# Read in a page
url = "https://docs.google.com/spreadsheets/d/1QkkIRF-3Qrz-aRIxERbGbB7YHWz2-t4ix-7TEcuBNfE/pubhtml?gid=1903959032&single=true"
page = Nokogiri::HTML(open(url), nil, 'utf-8')
rows = page.xpath('//table[@class="waffle"]/tbody/tr')

# Find something on the page using css selectors
content = []
rows.collect do |r|
  content << r.xpath('td').map { |td| td.text.strip }
end

# Builds records
content.shift
content.each do |row|

  record = {
    "id" => row[0],
    "macro_area" => row[1],
    "mensaje" => row[2],
    "total" => row[3],
    "last_update" => Date.today.to_s
  }

  # Storage records
  if ((ScraperWiki.select("* from data where `source`='#{record['id']}'").empty?) rescue true)
    ScraperWiki.save_sqlite(["id"], record)
    puts "Adds new record " + record['id']
  else
    ScraperWiki.save_sqlite(["id"], record)
    puts "Updating already saved record " + record['id']
  end
end
