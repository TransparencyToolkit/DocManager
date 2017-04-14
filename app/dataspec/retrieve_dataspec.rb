module RetrieveDataspec
  include GenerateDocModel
  # Gets the model for the data type
  def get_model(index, doc_type)
    project = get_project(index)
    datasource = project.datasources.where(class_name: doc_type).first
    classname = GenerateDocModel.gen_classname(datasource)
    return Kernel.const_get("GenerateDocModel::#{classname}")
  end

  # Get all the models for the project
  def get_all_models_for_project(index)
    project = get_project(index)
    return project.datasources.map{|source| get_model(index, source.class_name)}
  end

  # Get the project
  def get_project(index)
    Project.where(index_name: index).first
  end

  # Get the spec for the project
  def get_project_spec
    project = get_project(params["index_name"])
    render json: project.to_json
  end

  def get_dataspec_for_project_source(index_name, item_type)
    project = get_project(index_name)
    return project.datasources.where(class_name: item_type).first
  end

  # Get the dataspects for the project
  def get_dataspecs_for_project
    project = get_project(params["index_name"])
    render json: project.datasources.to_json
  end

  # Get the list of facets for the project
  def get_facet_list(index_name)
    project = get_project(index_name)
    project.datasources.inject([]) do |facets, d|
      facets += d.source_fields.select{|k, v| v["display_type"] == "Category"}.map{|k,v| k}
    end
  end

  # Get fields for long text
  def get_longtext_fields(index_name)
    project = get_project(index_name)
    project.datasources.inject([]) do |long, d|
      long += d.source_fields.select{|k, v| v["display_type"] == "Long Text"}.map{|k,v| k}
    end
  end

  # Get the list of fields for the project
  def get_search_field_list(index_name)
    project = get_project(index_name)
    non_search_fields = ["Date", "DateTime", "Link", "Number"]

    # Filter out non-search fields
    project.datasources.inject([]) do |fields, d|
      fields += d.source_fields.reject{|k, v| non_search_fields.include?(v["display_type"])}.map{|k,v| k}
    end
  end

  # Truncate highlighted field only when needed
  def highlight_fragments(field, index_name)
    longtext = get_longtext_fields(index_name)
    longtext.include?(field) ? (return {number_of_fragments: 0}) : (return {})
  end

  # Calls get_facet_list and used in controller- SIMILAR TO ABOVE
  def get_facet_details_for_project
    project = get_project(params["index_name"])
    
    facet_fields = project.datasources.inject({}) do |facets, d|
      facets.merge(d.source_fields.select{|k, v| v["display_type"] == "Category"})
    end
    
    render json: facet_fields
  end

  # Get the dataspec for the document
  def get_dataspec_for_doc
    # Parse out project, doc, and doc type
    project = get_project(params["index_name"])
    doc = JSON.parse(params["doc"])
    doc_type = doc["_type"].gsub("#{doc["_index"]}_", "").camelize

    # Return the dataspec
    dataspec = project.datasources.select{|d| d.class_name == doc_type}.first.to_json
    render json: dataspec
  end
end
