# Retrieve all documents 
module AllQuery

  # Get all the documents in index
  def query_all
    return lambda do |i|
      query_hash = {from: i*@return_size, size: @return_size}
      Elasticsearch::Model.search(query_hash, @models).response["hits"]["hits"]
    end
  end
end
