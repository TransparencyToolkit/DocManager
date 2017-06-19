module CreateUpdateDelete
  include RetrieveDataspec
  include GenerateID
  include DateParser
  include VersionTracker
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    doc_class = get_model(index_name, item_type)
    items.each_slice(1).each do |item_slice|
      create_bulk_items(item_slice, index_name, doc_class, item_type)
    end
  end

  # Process the fields in the document before creating
  def process_doc_fields(doc_data, index_name, doc_class, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)

    # Generate the ID 
    id = generate_id(doc_data, index_name, item_type)
    thread_id = set_thread_id(doc_data, index_name, item_type)

    # Add date and track versions
    processed_doc_data = remap_dates(index_name, item_type, doc_data).merge({id: id, thread_id: thread_id})
    return track_versions(processed_doc_data, doc_class, datasource).merge({id: id, thread_id: thread_id})
  end

  # Create items in bulk
  def create_bulk_items(items, index_name, doc_class, item_type)
     # Remap the items before indexing them in bulk        
    remapped_items = items.map do |item|
       processed_fields = process_doc_fields(item, index_name, doc_class, item_type)
       {index: {_id: processed_fields[:id], 
                data: processed_fields}}
     end
     
     # Index the documents in bulk
     Elasticsearch::Model.client = Elasticsearch::Client.new log: true, 
                                                             request_timeout: 10*60
     begin
       Elasticsearch::Model.client.bulk(index: index_name,
                                        type: index_name+"_"+item_type.underscore,
                                        body: remapped_items)
     rescue
       binding.pry
     end
  end
end
