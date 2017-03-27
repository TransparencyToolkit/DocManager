class Project
  def initialize(file)
    @project_config = JSON.parse(File.read(file))
  end

  # Load the index name
  def load_index_name
    @index_name = @project_config["index_name"]
  end

  # Load in all the datasources
  def load_datasources
    @datasources = @project_config["datasource_details"].inject({}) do |hash, source|
      hash[source[0]] = Datasource.new(source[1])
      hash
    end
  end

  # Load display details for project
  def load_display_details
    allowed_fields = ["title", "theme", "favicon", "logo", "info_links"]
    load_fieldset(@project_config, "display_details", allowed_fields)
  end

  # Load in the fields for the config section
  def load_fieldset(config, section_key, allowed)
    field_details = get_only_allowed(config[section_key], allowed)
    load_fields(field_details)
  end

  # Filter for only the allowed fields
  def get_only_allowed(field_hash, allowed)
    field_hash.select{|k,v| allowed.include?(k)}
  end

  # Load each individual field into instance variable
  def load_fields(field_hash)
    field_hash.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
