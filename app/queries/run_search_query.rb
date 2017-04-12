include QueryBuilder

module RunSearchQuery
  # Run the search query
  def run_full_query(search_term, search_field, project_index, start_offset, facet_params)
    # Run the search query
    query_hash = build_query(search_term, search_field, project_index, start_offset, facet_params)

    # Get models to search
    models = get_all_models_for_project(project_index)
    
    # Run the query
    Elasticsearch::Model.search(query_hash, models).response
  end

  # Parse the params for the query
  def run_query
    search_term = params["search_term"]
    search_field = params["search_field"]
    facet_params = params["facet_params"]
    project_index = params["index_name"]
    start_offset = params["start"]

    render json: JSON.pretty_generate(run_full_query(search_term, search_field, project_index, start_offset, facet_params))
  end
end
