module CreateUpdateDelete
  include RetrieveDataspec
  
  # Index an array of items
  def create_items(items, index_name, item_type)
    doc_class = get_model(index_name, item_type)
    items.each do |item|
      create_item(item, index_name, doc_class)
    end
  end
  
  # Index a new item
  def create_item(doc_data, index_name, doc_class)
    doc_class.create doc_data, index: index_name
  end
end
