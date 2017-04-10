require "rails_helper"
include QueryBuilder

RSpec.describe QueryBuilder do
  describe "query builder" do
    it "should generate a search query for all documents" do
      query = build_search_query("social", "_all", "tweet_people")
      expect(query[:simple_query_string][:fields].length).to eq(18)
    end

    it "should generate a full query for just a search term" do
      query = build_query("social", "_all", "tweet_people")
      expect(query[:simple_query_string][:fields].length).to eq(18)
    end
  end
end
