# Retrieve all documents with a certain field empty
module NilQuery

  # Get all the documents with an empty field
  def query_docs_with_empty_field(field_to_search)
    return lambda do |i|
      query_hash = {from: i*@return_size, size: @return_size, query: { bool: {must_not: {exists: {field: field_to_search}}}}}
      Elasticsearch::Model.search(query_hash, @models).response["hits"]["hits"]
    end
  end
end
