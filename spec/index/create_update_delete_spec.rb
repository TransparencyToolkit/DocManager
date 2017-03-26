require "rails_helper"
include CreateUpdateDelete

RSpec.describe CreateUpdateDelete do
  describe "create items" do
    it "should create a new doc" do
      CreateUpdateDelete.create_item({text: "hi I'm a document", id: 1}, "test_index4")
      sleep(1)
      doc = Elasticsearch::Model.client.search(index: "test_index4", body: { query:{ match: {_id: 1}}})["hits"]["hits"].first
      expect(doc["_source"]).to be_a(Hash)
    end
  end
end
