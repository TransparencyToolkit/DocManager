module CrudDatasource
  include GenerateDocModel
  def create_datasource(spec_file)
    found_datasource = datasource_exists?(spec_file)

    # Create datasource
    if !found_datasource
      source = Datasource.new
      source.parse_config(spec_file)
      source.project = self
      source.save
      found_datasource = source
    end

    # Create the doc model
    GenerateDocModel.gen_doc_class(found_datasource)
  end

  # Check if the datasource already exists for the project
  def datasource_exists?(spec_file)
    classname_in_spec = Datasource.new.parse_config(spec_file)["class_name"]
    existing_classes = self.datasources.map{|d| d.class_name}
    
    # If the class exists, retrieve it
    if existing_classes.include?(classname_in_spec)
      return self.datasources.select{|d| d.class_name == classname_in_spec}.first
    else
      return nil
    end
  end
end
