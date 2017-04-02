require "rails_helper"
include LoadDataspec
include IndexManager

RSpec.describe IndexController do
  describe "create items in response to query" do
    it "should create in response to an API call" do
      Elasticsearch::Model.client.indices.delete(index: 'tweet_people')
      load_all_dataspecs
      create_all_indexes
      items = File.read("spec/index/test_data_mult.json")

      # Call controller
      c = Curl::Easy.new("http://localhost:3000/add_items")
      c.http_post(Curl::PostField.content("item_type", "TwitterUser"),
                  Curl::PostField.content("index_name", "tweet_people"),
                  Curl::PostField.content("items", items))
     sleep(1)
     doc = Elasticsearch::Model.client.search(index: "tweet_people", body: { query:{ match: {name: "Transparency"}}})["hits"]["hits"]
     expect(doc.first["_source"]).to be_a(Hash)
     doc2 = Elasticsearch::Model.client.search(index: "tweet_people", body: { query:{ match: {name: "McGrath"}}})["hits"]["hits"].first
     expect(doc2["_source"]).to be_a(Hash)
    end
  end
end
