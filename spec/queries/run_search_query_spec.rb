require "rails_helper"
include RunSearchQuery
include IndexManager
include RetrieveDataspec

RSpec.describe RunSearchQuery do
  describe "run the search query" do
    it "should run a search query for all documents" do
      load_all_dataspecs
      create_all_indexes
      doc_class = get_model("tweet_people", "TwitterUser")
      test_data = JSON.parse(File.read("spec/index/test_data.json"))
      create_items(test_data, "tweet_people", "TwitterUser")
      sleep(1)
      
      query = run_query("social", "_all", "tweet_people", 0)
      binding.pry
      #expect(query[:simple_query_string][:fields].length).to eq(18)
    end
  end
end
