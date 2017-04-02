require "rails_helper"

RSpec.describe IndexManager do
  include IndexManager
  include LoadDataspec
  describe "index creation" do
    Project.delete_all
    it "should create a new index" do
      Elasticsearch::Model.client = Elasticsearch::Client.new log: true
      create_index("test_index4", Elasticsearch::Model.client)
      expect(Elasticsearch::Model.client.indices.exists? index: 'test_index4').to be_truthy
    end

    it "should create all indexes" do
      Project.delete_all
      Elasticsearch::Model.client.indices.delete(index: 'tweet_people')
      load_all_dataspecs
      create_all_indexes
      expect(Elasticsearch::Model.client.indices.exists? index: 'tweet_people').to be_truthy
      Elasticsearch::Model.client.indices.delete(index: 'tweet_people')
      Project.delete_all
    end
  end
end
