module CreateUpdateDelete
  include RetrieveDataspec
  include GenerateID
  include DateParser
  include VersionTracker
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    doc_class = get_model(index_name, item_type)
    create_bulk_items(items, index_name, doc_class, item_type)
   # items.each do |item|
  #    create_item(item, index_name, doc_class, item_type)
  #  end
  end

  # Process the fields in the document before creating
  def process_doc_fields(doc_data, index_name, doc_class, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)

    # Generate the ID 
    id = generate_id(doc_data, index_name, item_type)
    thread_id = set_thread_id(doc_data, index_name, item_type)

    # Add date and track versions
    processed_doc_data = remap_dates(index_name, item_type, doc_data).merge({id: id, thread_id: thread_id})
    return track_versions(processed_doc_data, doc_class, datasource)
  end

  # Create items in bulk
  def create_bulk_items(items, index_name, doc_class, item_type)
     # Remap the items before indexing them in bulk        
     remapped_items = items.map do |item| 
       {index: {_id: item["id"], 
                data: process_doc_fields(item, index_name, doc_class, item_type)}}
     end

     # Index the documents in bulk
     Elasticsearch::Model.client = Elasticsearch::Client.new log: true, 
                                                             request_timeout: 5*60
     begin
       Elasticsearch::Model.client.bulk(index: index_name,
                                        type: index_name+"_"+item_type.underscore,
                                        body: remapped_items)
     rescue
       binding.pry
     end
  end
  
  # Index a new item
  def create_item(doc_data, index_name, doc_class, item_type)
    processed_doc = process_doc_fields(doc_data, index_name, doc_class, item_type)

    # Create the doc or stop if it fails
    begin
      if doc_class.exists?(doc_data[:id])                              
        doc_class.find(doc_data[:id]).update(version_tracked, index: index_name)
      else
        doc_class.create version_tracked, index: index_name
      end
    rescue
      binding.pry
    end
  end
end
