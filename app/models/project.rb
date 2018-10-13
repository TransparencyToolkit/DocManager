class Project < ApplicationRecord
  include SetFields
  include CrudDatasource

  has_many :datasources
  has_many :recipes
  
  # Load in the config file
  def parse_config(project_json)
    project_config = JSON.parse(project_json)
    self.project_config = project_config
    load_fields(project_config["display_details"])
    self.index_name = project_config["index_name"]
    load_datasources
    return self
  end

  # Load in all the datasources
  def load_datasources
    JSON.parse(project_config["data_source_details"]).each do |spec_file|
      # NOTE: May need alternative when created via API rather than file- load separately (embedded JSON?)
      # But good to keep this option too- dynamically switch between
      create_datasource(File.read(spec_file))
    end
  end
end
