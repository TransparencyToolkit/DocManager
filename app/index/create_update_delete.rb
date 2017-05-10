module CreateUpdateDelete
  include RetrieveDataspec
  include GenerateID
  include DateParser
  include VersionTracker
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    doc_class = get_model(index_name, item_type)
    items.each do |item|
      create_item(item, index_name, doc_class, item_type)
    end
  end
  
  # Index a new item
  def create_item(doc_data, index_name, doc_class, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)

    # Generate the ID
    id = generate_id(doc_data, index_name, item_type)
    thread_id = set_thread_id(doc_data, index_name, item_type)

    # Process the data
    processed_doc_data = remap_dates(index_name, item_type, doc_data).merge({id: id, thread_id: thread_id})
    version_tracked = track_versions(processed_doc_data, doc_class, datasource)
    
    # Create the doc or stop if it fails
    begin
      doc_class.create version_tracked, index: index_name
    rescue
      binding.pry
    end
  end
end
