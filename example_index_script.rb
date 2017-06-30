require 'curb'
require 'json'

Dir["../gj-docs/processed_data/*"].each do |file|
  json = JSON.pretty_generate(JSON.parse(File.read(file)))
  c = Curl::Easy.new("http://localhost:3000/add_items")
  c.http_post(Curl::PostField.content("item_type", "LegalDocs"),
              Curl::PostField.content("index_name", "free_press_legal"),
              Curl::PostField.content("items", json))
end
