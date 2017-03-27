require "rails_helper"

RSpec.describe Project do
  describe "project gen" do
    let(:project_config) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) do
      Project.new(project_file: project_config)
   #   p.parse_config(project_config)
    #  p
    end
    
    it "should create a new project" do
      expect(project.project_config).to be_a(Hash)
    end

    it "should load display details" do
      project.load_display_details
      expect(project.instance_variable_get(:@title)).to eq("Tweet People")
      expect(project.instance_variable_get(:@theme)).to eq("default")
      expect(project.instance_variable_get(:@favicon)).to eq("tt-favicon.ico")
      expect(project.instance_variable_get(:@logo)).to eq("tt-logo.png")
      expect(project.instance_variable_get(:@info_links)).to be_a(Hash)
    end

    it "should load the index name" do
      project.load_index_name
      expect(project.index_name).to eq("tweet_people")
    end

    it "should generate the datasources" do
      test_datasource = Datasource.new("dataspec_files/data_sources/twitter_profiles.json").instance_variables
      project.load_datasources
      expect(project.instance_variable_get(:@datasources)).to be_a(Hash)
      expect(project.instance_variable_get(:@datasources).keys.length).to eq(1)
      expect(project.instance_variable_get(:@datasources)["TwitterUser"].instance_variables).to eq(test_datasource)
    end
  end
end
