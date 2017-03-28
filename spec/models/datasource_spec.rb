require "rails_helper"

RSpec.describe Datasource do
  describe "datasource gen" do
    let(:project_config) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) do
      p = Project.create
      p.parse_config(project_config)
      p
    end
    
    let(:datasource_config) {"dataspec_files/data_sources/twitter_profiles.json"}
    let(:datasource) do
      p = Datasource.new
      p.parse_config(datasource_config)
      p.project = project
      p
    end
    
    it "should create a new datasource" do
      expect(datasource.source_config).to be_a(Hash)
    end

    it "should load details about the datasource" do
      expect(datasource.name).to eq("Twitter Users")
      expect(datasource.description).to eq("Twitter profiles of users.")
      expect(datasource.input_params).to be_a(Hash)
    end

    it "should load details about the index" do
      expect(datasource.mapping).to eq("english")
      expect(datasource.class_name).to eq("TwitterUser")
    end

    it "should load details about the id" do
      expect(datasource.id_field).to eq("id")
      expect(datasource.secondary_id).to eq([])
      expect(datasource.trim_from_id).to be_a(Array)
    end

    it "should load details about version tracking" do
      expect(datasource.fields_to_track).to eq(["username", "description"])
      expect(datasource.most_recent_timestamp).to eq("created_at")
    end

    it "should load the fields" do
      expect(datasource.fields.length).to eq(18)
      expect(datasource.fields).to be_a(Hash)
      expect(datasource.fields["profile_image_url_https"]["human_readable"]).to eq("Profile Pic")
    end
  end
end
