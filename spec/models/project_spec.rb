require "rails_helper"

RSpec.describe Project do
  describe "project gen" do
    let(:project_config) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) do
      p = Project.new
      p.parse_config(project_config)
      p
    end
    
    it "should create a new project" do
      expect(project.project_config).to be_a(Hash)
    end

    it "should load display details" do
      expect(project.title).to eq("Tweet People")
      expect(project.theme).to eq("default")
      expect(project.favicon).to eq("tt-favicon.ico")
      expect(project.logo).to eq("tt-logo.png")
      expect(project.info_links).to be_a(Hash)
    end

    it "should load the index name" do
      expect(project.index_name).to eq("tweet_people")
    end

    it "should generate the datasources" do
      test_datasource = Datasource.new
      test_datasource.parse_config("dataspec_files/data_sources/twitter_profiles.json")
      expect(project.datasources).to be_a(Array)
      expect(project.datasources.length).to eq(1)
      expect(project.datasources.first.name).to eq(test_datasource.name)
    end
  end
end
