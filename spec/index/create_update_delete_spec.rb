require "rails_helper"
include CreateUpdateDelete
include RetrieveDataspec
include LoadDataspec
include IndexManager

RSpec.describe CreateUpdateDelete do
  describe "create items" do
    it "should create a new doc" do
      Elasticsearch::Model.client.indices.delete(index: 'tweet_people')
      load_all_dataspecs
      create_all_indexes
      doc_class = get_model("tweet_people", "TwitterUser")
      test_doc = JSON.parse(File.read("spec/index/test_data.json")).first
      CreateUpdateDelete.create_item(test_doc, "tweet_people", doc_class)
      sleep(1)
      doc = Elasticsearch::Model.client.search(index: "tweet_people", body: { query:{ match: {name: "Transparency"}}})["hits"]["hits"].first
      expect(doc["_source"]).to be_a(Hash)
    end

    it "should index multiple items" do
      test_data = JSON.parse(File.read("spec/index/test_data_mult.json"))
      create_items(test_data, "tweet_people", "TwitterUser")
      sleep(1)
      doc = Elasticsearch::Model.client.search(index: "tweet_people", body: { query:{ match: {name: "Transparency"}}})["hits"]["hits"].first
      expect(doc["_source"]).to be_a(Hash)
      doc2 = Elasticsearch::Model.client.search(index: "tweet_people", body: { query:{ match: {name: "McGrath"}}})["hits"]["hits"].first
      expect(doc2["_source"]).to be_a(Hash)
    end
  end
end
