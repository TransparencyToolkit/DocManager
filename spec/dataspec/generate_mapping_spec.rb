require "rails_helper"

RSpec.describe GenerateMapping do
  include LoadDataspec
  include GenerateMapping
  describe "generate mapping for each data source" do
    let(:project_path) {"dataspec_files/projects/tweetpeople.json"}
    let(:project) { create_project(project_path) }
    
    it "should infer a type for the field for the field" do
      expect(infer_type(project.datasources.first.source_fields.first)).to eq(String)
    end

    it "should generate an analyzer hash for the source" do
      analyzer_example = {analyzer: 'english', term_vector: 'with_positions_offsets_payloads'}
      expect(generate_analyzer_hash(project.datasources.first)).to eq(analyzer_example)
    end
  end
end
