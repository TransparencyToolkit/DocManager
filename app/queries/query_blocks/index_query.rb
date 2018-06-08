# Query template for querying the documents for the index page
module IndexQuery

  # Get all the documents that should be loaded on the index page
  def query_docs_for_index_page(start)
    # Get datasources to search
    sources = get_project(@index_name).datasources

    # Generate query hash with models, facet fields, start/size, sort field/order
    facet_query = gen_aggs_query(@index_name)
    query_hash = {from: start, size: 30, aggs: facet_query}

    # Sort responses in some circumstances
    if !sources.first.sort_field.empty?
      sort_field_type = sources.first.source_fields[sources.first.sort_field]["display_type"]
    
      # Sort by date or category
      if sort_field_type == "Date"
        query_hash[:sort] = {"#{sources.first.sort_field}" => {order: sources.first.sort_order, unmapped_type: "date"}}
      elsif sort_field_type == "Category"
        query_hash[:sort] = {"#{sources.first.sort_field}.keyword" => {order: sources.first.sort_order}}
      end
    end
    
    return lambda do 
      Elasticsearch::Model.search(query_hash, @models).response
    end
  end
end
