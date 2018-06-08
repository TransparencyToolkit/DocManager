# API calls for querying the documents in elasticsearch
class QueryController < ApplicationController
  include RunQuery
  include QueryBuilder

  # Set the index to query from
  before_action :set_index_name

  # Gets the documents on the index page
  def get_docs_on_index_page
    # Parse params
    start = params["start"].to_i
    
    # Call query and render
    render json: query_docs("index_page", start)
  end

  # Get the single doc passed in
  def get_doc
    # Get info it needs to search
    doc_id = params["doc_id"]

    # Search for document
    render json: query_docs("single_doc", doc_id)
  end

  # Get documents associated with a document
  def get_child_documents
    # Parse parameters
    doc_id = params["doc_id"]
    link_field = params["field"]
    
    # Query the document
    child_docs = query_docs("child_doc", doc_id, link_field).select{|c| c["_id"] != doc_id}

    # Map the child documents to be [id, title] for display
    remapped_children =  child_docs.map do |child|
      # Get the title field
      project = get_project(params["index_name"])
      doc_type = child["_type"].sub("#{params["index_name"]}_", "").camelize
      dataspec = project.datasources.select{|d| d.class_name == doc_type}
      title_field = dataspec.first.source_fields.select{|k,v| v["display_type"] == "Title"}.first[0]

      doc_title = child["_source"][title_field].strip.lstrip
      doc_title = child["_id"] if doc_title.empty?
      [child["_id"], doc_title]
    end
    render json: remapped_children
  end

  # Parse the params for the search query
  def run_search_query
    # Parse parameters
    search_query = JSON.parse(params["search_query"])
    facet_params = JSON.parse(params["facet_params"])
    range_query = JSON.parse(params["range_query"])
    start_offset = params["start"]

    # Run the search query
    render json: query_docs("search_query_display", search_query, range_query, facet_params, start_offset)
  end

  # Get documents matching search for Catalyst
  def run_query_catalyst
    # Parse the params
    search_query = params["search_query"]
    field_to_search = params["field_to_search"]

    # Run the search query
    render json: query_docs("search_query_catalyst", search_query, field_to_search)
  end

  # Get documents within a certain range
  def run_range_query_catalyst
    # Parse the params
    start_range = params["start_filter_range"]
    end_range = params["end_filter_range"]
    field_to_search = params["field_to_search"]

    # Run the search query
    render json: query_docs("range_query_catalyst", field_to_search, start_range, end_range)
  end
  
  # Get the docs with the same thread ID
  def get_docs_in_thread
    # Get thread ID
    thread_id = params["thread_id"]

    # Return the thread
    render json: query_docs("thread_query", thread_id)
  end

  # Get a JSON of all the docs
  def get_all_docs
    render json: query_docs("get_all_docs")
  end

  # Get the total number of documents in the index
  def get_total_docs
    render json: query_docs("total_docs")
  end

  # Get the count of documents in the collection
  def get_collection_doc_total
    collection = params["collection"]
    render json: query_docs("num_docs_in_collection", collection)
  end

  # Get documents with an empty field
  def get_nil_docs
    field_to_search = params["field_to_search"]
    render json: query_docs("empty_field", field_to_search)
  end

  # Get the term vector for a document
  def get_term_vector
    doc_id = params["doc_id"]
    fields_to_check = params["fields_to_check"]
    doc_type = params["doc_type"]
    render json: query_docs("term_vector_query", doc_id, fields_to_check, doc_type)
  end

  private

  # Set the index name appropriately
  def set_index_name
    @index_name = params["index_name"]
  end
end
