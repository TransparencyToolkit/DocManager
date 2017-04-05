load 'dataspec/retrieve_dataspec.rb'

# Get the count of documents available in different sets
module CountQueries
  include RetrieveDataspec

  # Get the total number of documents in the index
  def get_total_docs
    models = get_all_models_for_project(params["index_name"])
    total_count = Elasticsearch::Model.search({from: 0, size: 1}, models).response["hits"]["total"]
    render json: total_count
  end
end
