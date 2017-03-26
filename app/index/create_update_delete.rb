module CreateUpdateDelete
  def create_item(doc_data, index_name)
    Doc.create doc_data, index: index_name
  end
end
