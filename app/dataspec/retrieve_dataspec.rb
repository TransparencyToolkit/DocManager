load 'app/dataspec/generate_doc_model.rb'

module RetrieveDataspec
  include GenerateDocModel
  # Gets the model for the data type
  def get_model(index, doc_type)
    project = get_project(index)
 #   datasource = project.datasources.where(class_name: doc_type)
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
  def project_spec
    return get_project(params["index_name"])
  end

  def get_dataspec_for_project_source(index_name, item_type)
    project = get_project(index_name)
    return project.datasources.where(class_name: item_type).first
  end

  # Get the dataspects for the project
  def dataspecs_for_project
    project = get_project(params["index_name"])
    return project.datasources
  end

  # Get the list of facets for the project
  def get_facet_list(index_name)
    project = get_project(index_name)
    
    project.datasources.inject([]) do |facets, d|
      facets += d.source_fields.select{|k, v| v["display_type"] == "Category"}.map{|k,v| k}
    end
  end

  # Return JSON with facets divided by source
  def facet_list_divided_by_source
    project = get_project(params["index_name"])

    # Get a list of all facets that occur more than once
    all_facets = get_facet_list(params["index_name"])
    overall_facet_names = all_facets.select{|facet| all_facets.count(facet) > 1}.uniq
    overall_facets = get_facet_details.select{|k, v| overall_facet_names.include?(k)}
    
    # Divide the facets by source
    return project.datasources.inject({"overall" => overall_facets}) do |list, source|
      facets_for_source = source.source_fields.select{|k, v| v["display_type"] == "Category"}.except(*overall_facet_names)
      list[source["name"]] = facets_for_source
      list
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
    non_search_fields = ["Date", "DateTime", "Link", "Number", "Hidden", "Attachment", "None"]

    # Filter out non-search fields
    project.datasources.inject([]) do |fields, d|
      fields += d.source_fields.reject{|k, v| non_search_fields.include?(v["display_type"])}.map{|k,v| k}
    end
  end

  # Truncate highlighted field only when needed
  def highlight_fragments(field, index_name)
    longtext = get_longtext_fields(index_name)
    longtext.include?(field) ? (return {number_of_fragments: 1, fragment_size: 500}) : (return {})
  end

  # Gets the acet details for the project
  def get_facet_details
    facet_fields = get_facet_list(params["index_name"])
    project = get_project(params["index_name"])
    
    facet_fields = project.datasources.inject({}) do |facets, d|
      facets.merge(d.source_fields.select{|k, v| v["display_type"] == "Category"})
    end
  end

  # Get the dataspec for the document
  def dataspec_for_doc
    # Parse out project, doc, and doc type
    project = get_project(params["index_name"])
    doc_type = params["doc_type"].sub("#{params["index_name"]}_", "").camelize
   
    # Return the dataspec
    return project.datasources.select{|d| d.class_name == doc_type}.first.to_json
  end
end
