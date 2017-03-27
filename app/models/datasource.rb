class Datasource
  def initialize(file)
    @source_config = JSON.parse(File.read(file))
  end

  # Generates the fields for the data source
  def gen_fields
    @fields = @source_config["fields"]
  end

  # Loads the basic details about the source
  def load_datasource_details
    source_details = @source_config["data_source_details"]
    @source_name = source_details["name"]
    @description = source_details["description"]
    @input_params = source_details["input_params"]
  end

  # Load the details needed to index the data
  def load_index_details
    source_details = @source_config["index_details"]
    @mapping = source_details["mapping"]
    @class_name = source_details["class_name"]
  end

  # Load in info on the ID field
  def load_id_details
    source_details = @source_config["id_details"]
    @id_field = source_details["id_field"]
    @secondary_id = source_details["secondary_id"]
    @trim_from_id = source_details["trim_from_id"]
  end

  # Load in the details related to version tracking
  def load_version_tracking_details
    source_details = @source_config["version_tracking_details"]
    @fields_to_track = source_details["fields_to_track"]
    @most_recent_timestamp = source_details["most_recent_timestamp"]
  end
end
