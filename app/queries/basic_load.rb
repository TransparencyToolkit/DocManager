load 'dataspec/retrieve_dataspec.rb'

# Queries that are not for search, but just loading the set of docs specified
module BasicLoad
  include RetrieveDataspec

  # Get the single doc passed in
  def get_doc
    # Get info it needs to search
    doc_id = params["doc_id"]
    index = params["index_name"]
    models = get_all_models_for_project(index)
    
    # Search for document
    doc = Elasticsearch::Model.search({query: {match: {"_id" => doc_id}}}, models).response["hits"]["hits"].first
    render json: JSON.pretty_generate(doc)
  end
  
  # Get page of results
  def get_docs_on_index_page
    # Parse params
    start = params["start"].to_i
    index_name = params["index_name"]
    sources = get_project(index_name).datasources

    # Generate query hash with models, facet fields, start/size, sort field/order
    models = get_all_models_for_project(index_name)
    facet_query = gen_aggs_query(index_name)
    query_hash = {from: start, size: 30, aggs: facet_query}
    query_hash[:sort] = {"#{sources.first.sort_field}" => {order: sources.first.sort_order, unmapped_type: "date"}} if !sources.first.sort_field.empty? && sources.length == 1
    render json: JSON.pretty_generate(Elasticsearch::Model.search(query_hash, models).response)
  end

  # Get the docs with the same thread ID
  def get_docs_in_thread
    # Parse params
    index_name = params["index_name"]
    thread_id = params["thread_id"]
    models = get_all_models_for_project(index_name)

    # Get the thread
    docs = Elasticsearch::Model.search({query: {term: {"thread_id.keyword" => thread_id}}, size: 100}, models).response["hits"]["hits"]
    render json: JSON.pretty_generate(docs)
  end

  # Get a JSON of all the docs
  def get_all_docs
    index_name = params["index_name"]
    models = get_all_models_for_project(index_name)
    query_hash = {from: 0, size: 999999}
    render json: JSON.pretty_generate(Elasticsearch::Model.search(query_hash, models).response)
  end
end
