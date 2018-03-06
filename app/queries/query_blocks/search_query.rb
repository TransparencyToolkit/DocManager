# Retrieve documents matching query
module SearchQuery

  # Get all documents matching a certain term
  def search_query_catalyst(search_query, field_to_search)
    initial_query = build_search_query(search_query, field_to_search, @project_index)
    return lambda do |i|
      query_hash = {from: i*@return_size, size: @return_size, query: initial_query}
      Elasticsearch::Model.search(query_hash, @models).response["hits"]["hits"]
    end
  end

  # Get documents matching query in chunks of 30
  def search_query_display(search_query, range_query, facet_params, start_offset)
    query_hash = build_query(search_query, range_query, @index_name, start_offset, facet_params)
    
    return lambda do
      Elasticsearch::Model.search(query_hash, @models).response
    end
  end
end
