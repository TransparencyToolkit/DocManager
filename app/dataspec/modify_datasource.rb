# Methods to add and remove fields from the datasource
module ModifyDatasource
  include GenerateMapping
  
  # Add a field to a source
  def add_field_to_source(field_name, field_hash, doc_class, project_index)
    # Get the correct source to modify
    source_to_change = find_source_to_modify(doc_class, project_index)

    # Add the field
    source_to_change.update_attributes(source_fields: source_to_change.source_fields.merge({field_name => field_hash}))

    # Update the mapping in elastic
    add_field_to_mapping(project_index, doc_class, source_to_change, field_name, field_hash)
  end

  # Remove a field from the data source
  def remove_field_from_source(field_name, doc_class, project_index)
    # Get the correct source to modify
    source_to_change = find_source_to_modify(doc_class, project_index)

    # Remove the field
    source_to_change.update_attributes(source_fields: source_to_change.source_fields.except(field_name))

    # Remove from elastic
    remove_field_from_elastic(project_index, doc_class, field_name)
  end

  # Find the source with the matching index and class name
  def find_source_to_modify(doc_class, project_index)
    return Project.find_by(index_name: project_index).datasources.find_by(class_name: doc_class)
  end

  # Remove a field from the mapping
  def remove_field_from_elastic(project_index, doc_class, field_name)
    # Get the document model
    doc_model = get_model(project_index, doc_class)

    # Remove the method for the attribute from the class
    doc_model.remove_possible_method(field_name)

    # Remove field from all documents of type in elastic (does not update mapping, need to change when types removed)
    client = Elasticsearch::Model.client
    client.update_by_query index: project_index, type: doc_model.document_type,
                                   body: {
                                     script: { inline: 'ctx._source.remove("'+field_name+'")'},
                                   }
  end

  # Update the mapping in elasticsearch and the corresponding class object
  def add_field_to_mapping(project_index, doc_class, source_to_change, field_name, field_hash)
    # Get the document model and analyzer
    doc_model = get_model(project_index, doc_class)
    analyzer_hash = generate_analyzer_hash(source_to_change)

    # Reopen the model class and add to the mapping
    doc_model.class_eval do
      gen_mapping_for_field([field_name, field_hash.stringify_keys], analyzer_hash)
    end
  end
end
