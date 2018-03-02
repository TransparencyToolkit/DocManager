class Project < ApplicationRecord
  include SetFields
  include CrudDatasource

  has_many :datasources
  
  # Load in the config file
  def parse_config(project_file)
    project_config = JSON.parse(File.read(project_file))
    self.project_config = project_config
    load_fields(project_config["display_details"])
    self.index_name = project_config["index_name"]
    load_datasources
    return self
  end

  # Load in all the datasources
  def load_datasources
    JSON.parse(project_config["data_source_details"]).each do |spec_file|
      create_datasource(spec_file)
    end
  end
end
