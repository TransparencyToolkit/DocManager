# Retrieve children associated with particular document
module ChildDocQuery

  # Get all documents matching a certain term
  def find_children(doc_id, link_field)
    # Extract field to match by
    doc = query_docs("single_doc", doc_id)
    link_val = doc["_source"][link_field]

    # Find other documents with same value in that field
    return search_query_catalyst(link_val, link_field)
  end

end
