class Datasource
  include LoadDataspec
  include SetFields
  include Mongoid::Document
  embedded_in :project

  # Config file
  field :source_config, type: Hash

  # datasource_details
  field :name, type: String
  field :description, type: String
  field :icon, type: String
  field :input_params, type: Hash

  # index_details
  field :mapping, type: String
  field :class_name, type: String

  # sort_details
  field :sort_field, type: String
  field :sort_order, type: String
  field :thread_id_field, type: String

  # view_details
  field :show_tabs, type: Array
  field :results_template, type: String

  # id_details
  field :id_field, type: String
  field :secondary_id, type: Array
  field :trim_from_id, type: Array

  # version_tracking_details
  field :fields_to_track, type: Array
  field :most_recent_timestamp, type: String

  field :source_fields, type: Hash

  # Load in the config file
  def parse_config(file)
    self.source_config = JSON.parse(File.read(file))
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
