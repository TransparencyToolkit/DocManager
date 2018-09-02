# Retrieve the term vector for a document
module TermVectorQuery

  # Get term vector for query from Elastic
  def term_vector_catalyst(doc_id, fields_to_check, type)
    # Generate query to be run
    doc_type = @index_name+"_"+type.underscore
    fields = JSON.parse(fields_to_check).join(",")
    url = ENV['ELASTICSEARCH_URL']
    query = "http://#{url}/#{@index_name}/#{doc_type}/#{doc_id}/_termvectors"
    get_filter = {
      fields: fields,
       term_statistics: true,
       field_statistics: true,
       positions: true,
       offsets: true
    }
    
    return lambda do
      Curl.get(query, get_filter).body_str
    end
  end
end
