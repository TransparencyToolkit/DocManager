# Get the count of documents available in different sets
module CountQuery
  # Get the total number of documents in the index
  def total_doc_count
    lambda do
      Elasticsearch::Model.search({from: 0, size: 0}, @models).response["hits"]["total"]
    end
  end

  # Get the total number of documents in the index for a type
  def total_doc_count_for_type(doc_type)
    models_to_check = filter_models_to_check(doc_type)
    
    lambda do
      Elasticsearch::Model.search({from: 0, size: 0}, models_to_check).response["hits"]["total"]
    end
  end

  # Get the count of documents in the collection
  def collection_doc_total(collection)
    lambda do
      Elasticsearch::Model.search({from: 0, size: 0,
                                   query: {
                                     match: {"collection_tag" => collection}}
                                  }, @models).response["hits"]["total"]
    end
  end
end
