module CreateUpdateDelete
  include RetrieveDataspec
  include GenerateID
  include DateParser
  include VersionTracker
  include RetryUtils
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    created_item_ids = Array.new
    doc_class = get_model(index_name, item_type)

    # Add previously created items
    items.each_slice(1).each do |item_slice|
      created_item_ids += create_bulk_items(item_slice, index_name, doc_class, item_type)
    end

    return created_item_ids
  end

  # Process the fields in the document before creating
  def process_doc_fields(doc_data, index_name, doc_class, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)

    # Remove fields that shouldn't be in the json
    doc_data = remove_unspecified_fields(doc_data, datasource)
    
    # Generate the ID 
    id = generate_id(doc_data, index_name, item_type)
    thread_id = set_thread_id(doc_data, index_name, item_type)

    # Add date and track versions
    processed_doc_data = remap_dates(index_name, item_type, doc_data).merge({id: id, thread_id: thread_id})
    processed_doc_data = remap_blank_to_nil(processed_doc_data)
    return track_versions(processed_doc_data, doc_class, datasource).merge({id: id,
                                                                            thread_id: thread_id,
                                                                            last_updated: Time.now})
  end

  # Remove fields not in the dataspec before indexing
  def remove_unspecified_fields(doc, datasource)
    allowed_fields = datasource.source_fields.keys+["id"]
    return doc.keep_if{|k, v| allowed_fields.include?(k)}
  end
  
  # Remap blank values to nil
  def remap_blank_to_nil(processed_doc_data)
    processed_doc_data.to_a.map do |v|
      v[1] = nil if v[1].blank?
      [v[0], v[1]]
    end.to_h
  end

  # Create items in bulk
  def create_bulk_items(items, index_name, doc_class, item_type)
    item_ids = Array.new
    
    # Remap the items before indexing them in bulk        
    remapped_items = items.map do |item|
      processed_fields = process_doc_fields(item, index_name, doc_class, item_type)
      item_ids.push(processed_fields[:id])
       {index: {_id: processed_fields[:id], 
                data: processed_fields}}
     end
    
     # Index the documents in bulk
     Elasticsearch::Model.client = Elasticsearch::Client.new log: true, 
                                                             request_timeout: 10*60
    
     begin
       query_retry(0) { Elasticsearch::Model.client.bulk(index: index_name,
                                        type: index_name+"_"+item_type.underscore,
                                        body: remapped_items) }
     rescue
       binding.pry
     end

     # Return a list of items created
     return item_ids
  end

  # Delete all the items passed in from elastic
  def delete_items_from_elastic(items)
    items.map{|i| {id: i["_id"], type: i["_type"], index: i["_index"]}}.each do |item|
      Elasticsearch::Model.client.delete item
    end
  end
  
end
