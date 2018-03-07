class Datasource < ApplicationRecord
  include LoadDataspec
  include SetFields

  belongs_to :project

  # Load in the config file
  def parse_config(config_json)
    source_config = JSON.parse(config_json)
    self.source_config = JSON.parse(config_json)
    load_fields(source_config["data_source_details"])
    load_fields(source_config["index_details"])
    load_fields(source_config["sort_details"])
    load_fields(source_config["view_details"])
    load_fields(source_config["id_details"])
    load_fields(source_config["version_tracking_details"])
    self.source_fields = source_config["fields"].merge(load_overall_fields)
    return self
  end
end
