module CreateUpdateDelete
  include RetrieveDataspec
  include GenerateID
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    doc_class = get_model(index_name, item_type)
    items.each do |item|
      create_item(item, index_name, doc_class, item_type)
    end
  end
  
  # Index a new item
  def create_item(doc_data, index_name, doc_class, item_type)
    id = generate_id(doc_data, index_name, item_type)
    doc_class.create doc_data.merge(id: id), index: index_name
  end
end
