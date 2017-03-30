module CrudDatasource
  def create_datasource(spec_file)
    if !datasource_exists?(spec_file)
      source = Datasource.new
      source.parse_config(spec_file)
      source.project = self
      source.save
    end
  end

  # Check if the datasource already exists for the project
  def datasource_exists?(spec_file)
    classname_in_spec = Datasource.new.parse_config(spec_file)["class_name"]
    existing_classes = self.datasources.map{|d| d.class_name}
    return existing_classes.include?(classname_in_spec)
  end
end
