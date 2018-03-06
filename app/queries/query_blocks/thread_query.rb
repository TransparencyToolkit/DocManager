# Retrieve all documents in thread
module ThreadQuery

  # Get all the documents in a thread
  def query_thread(thread_id)
    return lambda do |i|
      Elasticsearch::Model.search({query: {term: {"thread_id.keyword" => thread_id}}, from: i*@return_size, size: @return_size}, @models).response["hits"]["hits"]
    end
  end
end
