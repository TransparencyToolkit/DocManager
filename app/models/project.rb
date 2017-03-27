class Project
  include SetFields
  include Mongoid::Document
  # Config/settings
  field :project_file, type: String
  field :project_config, type: Hash

  # Index and data sources
  field :index_name, type: String
  field :datasources, type: Hash

  # Project details
  field :title, type: String
  field :theme, type: String
  field :favicon, type: String
  field :logo, type: String
  field :info_links, type: Hash
  
  # Load in the config file
  def parse_config(project_file)
    self.project_config = JSON.parse(File.read(project_file))
    #    load_datasources
    load_fields(project_config["display_details"])
    self.index_name = project_config["index_name"]
  end

  # Load in all the datasources
  def load_datasources
    self.datasources = project_config["datasource_details"].inject({}) do |hash, source|
      hash[source[0]] = Datasource.new(source[1])
      hash
    end
  end
end
