load 'dataspec/retrieve_dataspec.rb'

module QueryBuilder
  include RetrieveDataspec
  
  # Build the query
  def build_query(search_term, field_to_search, project_index, start_offset)
    # Generate combined search query
    search_query = build_search_query(search_term, field_to_search, project_index)
    facet_query = nil
    combined_query = combine_search_and_facet_queries(search_query, facet_query)

    # Get the facets to load and things to highlight
    aggs_hash = gen_aggs_query(project_index)
    highlight_fields = get_highlight_field_list(project_index)

    # Finish building query
    return {from: start_offset, size: 30, query: combined_query, aggs: aggs_hash,
            highlight: { pre_tags: ["<b class='is_highlighted'>"], post_tags: ["</b>"], fields: highlight_fields}}
  end
  
  # Builds the query based on input to search fields
  def build_search_query(search_term, field_to_search, project_index)
    # Handle queries for all fields
    field_to_search = get_search_field_list(project_index) if field_to_search == "_all"

    # Create the query
    return {
      simple_query_string: {
        query: search_term,
        fields: field_to_search,
        default_operator: "AND",
        flags: "AND|OR|PHRASE|PREFIX|NOT|FUZZY|SLOP|NEAR"
      }}
  end

  # Combine search and facet queries based on if it is search and facets, just search, just facets
  def combine_search_and_facet_queries(search_query, facet_query)
    if !facet_query.blank? && !search_query.blank?
      full_query = { filtered: { query: search_query, filter: facet_query }}
    elsif search_query.blank?
      full_query = { filtered: { filter: facet_query}}
    else
      full_query = search_query
    end
    return full_query
  end

  # Generate aggergations query
  def gen_aggs_query(index_name)
    facets = get_facet_list(index_name)

    # Make query hash
    return facets.inject({}) do |h, field|
      h[field.to_sym] = {terms: {field: field+".keyword", size: 500}}
      h
    end
  end
end
