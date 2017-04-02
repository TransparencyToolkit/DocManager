require "rails_helper"
load "app/dataspec/load_dataspec.rb"
load "app/index/index_manager.rb"


RSpec.describe RetrieveDataspec do
  include RetrieveDataspec
  include LoadDataspec
  include IndexManager
  describe "load in parts of the dataspec or models for use elsewhere" do
    it "should get the class for the index and data type" do
      Project.delete_all
      load_all_dataspecs
      create_all_indexes
      expect(get_model("tweet_people", "TwitterUser").class).to eq(Class)
      Project.delete_all
    end
    
   # it "should create models for all sources" do
   #   expect(GenerateDocModel.gen_classname(project.datasources.first)).to eq("TweetPeopleTwitterUser")
   # end
  end
end
