# Retrieve documents to export
module ExportQuery

  # Get all documents matching a certain term
  def get_docs_to_export(last_updated_date, pub_selector_field, acceptable_to_publish_values, doc_type)
    date_since_query = { "last_updated" => {gte: last_updated_date}}
    to_publish_filter = {"#{pub_selector_field}.keyword" => acceptable_to_publish_values }
    models_to_check = filter_models_to_check(doc_type)
    
    return lambda do |i|
      query_hash = {from: i*@return_size, size: @return_size, query: {
                      bool: {
                        must: {
                          range: date_since_query},
                        filter: {
                          terms: to_publish_filter} }}}
      Elasticsearch::Model.search(query_hash, @models).response["hits"]["hits"]
    end
  end
end
