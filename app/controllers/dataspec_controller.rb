# API calls for querying the dataspec in elasticsearch
class DataspecController < ApplicationController
  include RetrieveDataspec
  include ModifyDatasource
  
  def add_field
    # Parse fields
    field_name = params["field_name"]
    field_hash = JSON.parse(params["field_hash"])
    doc_class = params["doc_class"]
    project_index = params["project_index"]

    # Add the field
    add_field_to_source(field_name, field_hash, doc_class, project_index)
  end

  def remove_field
    # Parse fields
    field_name = params["field_name"]
    doc_class = params["doc_class"]
    project_index = params["project_index"]

    # Remove the field
    remove_field_from_source(field_name, doc_class, project_index)
  end
  
  def get_facet_details_for_project
    render json: get_facet_details
  end

  def get_project_spec
    render json: project_spec
  end

  def get_dataspec_for_doc
    render json: dataspec_for_doc
  end

  def get_dataspecs_for_project
    render json: dataspecs_for_project
  end

  def get_facet_list_divided_by_source
    render json: facet_list_divided_by_source
  end
end
