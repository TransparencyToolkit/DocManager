# Retrieve a single document
module SingleDocQuery

  # Retrieve a single document
  def retrieve_single_doc(doc_id)
    return lambda do
      Elasticsearch::Model.search({query: {match: {"_id" => doc_id}}}, @models).response["hits"]["hits"].first
    end
  end
end
