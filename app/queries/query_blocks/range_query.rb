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
end
