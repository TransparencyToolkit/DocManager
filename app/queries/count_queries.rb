load 'dataspec/retrieve_dataspec.rb'

# Get the count of documents available in different sets
module CountQueries
  include RetrieveDataspec

  # Get the total number of documents in the index
  def get_total_docs
    models = get_all_models_for_project(params["index_name"])
    render json: Elasticsearch::Model.search({from: 0, size: 0}, models).response["hits"]["total"]
  end

  # Get the count of documents in the collection
  def get_collection_doc_total
    models = get_all_models_for_project(params["index_name"])
    render json: Elasticsearch::Model.search({from: 0, size: 0,
                                               query: {
                                                 match: {"collection_tag" => params["collection"]}}
                                              }, models).response["hits"]["total"]
  end
end
