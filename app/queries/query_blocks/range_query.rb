# Retrieve documents within a certain range of dates
module RangeQuery

  # Get all documents matching a certain term
  def range_query_catalyst(field_to_search, start_range, end_range)
    initial_query = {field_to_search => {gte: start_range, lte: end_range}}
    
    return lambda do |i|
      query_hash = {from: i*@return_size, size: @return_size, query: { range: initial_query }}
      Elasticsearch::Model.search(query_hash, @models).response["hits"]["hits"]
    end
  end

  # Get number documents matching a certain range
  def range_query_catalyst_count(field_to_search, start_range, end_range, doc_type)
    initial_query = {field_to_search => {gte: start_range, lte: end_range}}
    models_to_check = filter_models_to_check(doc_type)
    
    return lambda do
      query_hash = {from: 0, size: 0, query: { range: initial_query }}
      Elasticsearch::Model.search(query_hash, models_to_check).response["hits"]["total"]
    end
  end
end
