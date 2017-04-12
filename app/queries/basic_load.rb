load 'dataspec/retrieve_dataspec.rb'

# Queries that are not for search, but just loading the set of docs specified
module BasicLoad
  include RetrieveDataspec
  
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
    query_hash[:sort] = {sources.first.sort_field => sources.first.sort_order} if !sources.first.sort_field.empty?

    render json: JSON.pretty_generate(Elasticsearch::Model.search(query_hash, models).response)
  end
end
