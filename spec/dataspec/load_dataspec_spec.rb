require "rails_helper"

RSpec.describe LoadDataspec do
  include LoadDataspec
  describe "load projects" do
    let(:project_path) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) { create_project(project_path) }
    Project.delete_all
    
    it "should find all the projects" do
      expect(find_projects).to include(project_path)
    end

    it "should load in the project" do
      expect(project.title).to eq("Tweet People")
      expect(project.theme).to eq("default")
      expect(project.favicon).to eq("tt-favicon.ico")
      expect(project.logo).to eq("tt-logo.png")
      expect(project.info_links).to be_a(Hash)
      expect(project.datasources.length).to eq(1)
      Project.delete_all
    end

    it "should check if the project already exists" do
      p1 = project
      expect(project_exists?(project_path)).to be_truthy
      Project.delete_all
    end

    it "should load all the projects" do
      load_all_dataspecs
      expect(Project.all.length).to eq(1)
      Project.delete_all
    end

    it "should update the project" do
      # Make a modified version of project
      p1 = project
      original = JSON.parse(File.read(project_path))
      new_project = JSON.parse(File.read(project_path))
      new_project["display_details"]["title"] = "Tweety People"
      File.write(project_path, JSON.pretty_generate(new_project))

      # Test and clean up
      expect(load_project(project_path).title).to eq("Tweety People")
      File.write(project_path, JSON.pretty_generate(original))
      Project.delete_all
    end
  end
end
