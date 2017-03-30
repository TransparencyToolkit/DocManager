class Datasource
  include SetFields
  include Mongoid::Document
  embedded_in :project

  # Config file
  field :source_config, type: Hash

  # datasource_details
  field :name, type: String
  field :description, type: String
  field :input_params, type: Hash

  # index_details
  field :mapping, type: String
  field :class_name, type: String

  # id_details
  field :id_field, type: String
  field :secondary_id, type: Array
  field :trim_from_id, type: Array

  # version_tracking_details
  field :fields_to_track, type: Array
  field :most_recent_timestamp, type: String

  # Load in the config file
  def parse_config(file)
    self.source_config = JSON.parse(File.read(file))
    load_fields(source_config["data_source_details"])
    load_fields(source_config["index_details"])
    load_fields(source_config["id_details"])
    load_fields(source_config["version_tracking_details"])
    self.fields = source_config["fields"]
    return self
  end
end
