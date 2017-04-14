load 'dataspec/retrieve_dataspec.rb'

module QueryBuilder
  include RetrieveDataspec
  
  # Build the query
  def build_query(search_query, range_query, project_index, start_offset, facet_params)
    # Generate combined search query
    field_query_list = search_query.inject([]) do |query_list, queries_for_source|
      queries_for_source[1].each do |field, value|
        field_to_query = field
        query_list.push(build_search_query(value, field_to_query, project_index))
      end
      query_list
    end
    
    facet_query = build_facet_filter_query(facet_params)
    combined_query = combine_search_and_facet_queries(field_query_list, facet_query, range_query)
    
    # Get the facets to load and things to highlight
    aggs_hash = gen_aggs_query(project_index)
    highlight_fields = build_highlight_query(project_index, search_query)

    # Finish building query
    return {from: start_offset, size: 30, query: combined_query, aggs: aggs_hash,
            highlight: { pre_tags: ["<b class='is_highlighted'>"], post_tags: ["</b>"], fields: highlight_fields}}
  end
  
  # Builds the query based on input to search fields
  def build_search_query(search_term, field_to_search, project_index)
    # Handle queries for all fields or just one
    field_to_search = field_to_search == "_all" ? get_search_field_list(project_index) : [field_to_search]

    # Create the query
    return {
      simple_query_string: {
        query: search_term,
        fields: field_to_search,
        default_operator: "AND",
        flags: "AND|OR|PHRASE|PREFIX|NOT|FUZZY|SLOP|NEAR" 
      }}
  end

  # Build a list of facet filters
  def build_facet_filter_query(facets)
    return facets.map{|i| {term: i}}
  end

  # Combine search and facet queries based on if it is search and facets, just search, just facets
  def combine_search_and_facet_queries(search_query, facet_query, range_query)
    combined_query_hash = {}
    combined_query_hash[:must] = search_query if !search_query.blank?
    (combined_query_hash[:must]||= []).push({range: range_query}) if !range_query.blank?
    combined_query_hash[:filter] = facet_query if !facet_query.blank?

    return { bool: combined_query_hash }
  end

  # Highlight the fields that are being searched
  def build_highlight_query(project_index, search_query)
    # Get list of fields to highlight
    highlight_list = search_query.inject([]){|highlight, params| highlight.push(params[1].first[0])}
    highlight_list += get_search_field_list(project_index) if highlight_list.include?("_all")

    # Generate the highlight hash
    return highlight_list.uniq.inject({}) do |highlight, field|
      highlight[field] = highlight_fragments(field, project_index)
      highlight
    end
    
    # TODO:
    # Make work for all
    # Possibly remoe highlight method
    # Test (ONLY highlight searched)
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
