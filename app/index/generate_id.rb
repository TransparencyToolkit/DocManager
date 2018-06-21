# Generate the ID and (separately) set the thread ID
module GenerateID
  # Set thread ID. If it is nil, set to ID field
  def set_thread_id(doc_data, index_name, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)
    
    # Set to ID if thread ID is blank, otherwise return thread ID
    if !datasource.thread_id_field || doc_data[datasource.thread_id_field].blank?
      return generate_id(doc_data, index_name, item_type)
    else
      return doc_data[datasource.thread_id_field]
    end
  end
  
  # Generate the ID
  def generate_id(doc_data, index_name, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)
    id = get_secondary_id(datasource, doc_data, get_primary_id(datasource, doc_data), index_name, item_type)
    return add_doc_type(index_name, item_type, id, datasource)
  end

  # Add the document type/index to the ID
  def add_doc_type(index_name, item_type, id, datasource)
    "#{id.gsub(datasource.trim_from_id[0], "")}_#{index_name}_#{item_type.underscore}"
  end

  # Return the primary ID
  def get_primary_id(datasource, doc_data)
    clean_id(doc_data[datasource.id_field])
  end

  # Get the secondary ID fields
  def get_secondary_id(datasource, doc_data, id, index_name, item_type)
    return datasource.secondary_id.inject(id) do |id, field|
      processed_field = remap_dates(index_name, item_type, doc_data)[field]
      id += clean_id(processed_field).to_s
    end
  end

  # Removes non-urlsafe chars from ID
  def clean_id(str)
    if str.is_a?(Date)
      return str.strftime
    elsif str
      return str.to_s.gsub("/", "").gsub(" ", "").gsub(",", "").gsub(":", "").gsub(";", "").gsub("'", "").gsub(".", "").gsub("?", "").gsub("(", "").gsub(")", "")
    end
  end
end
