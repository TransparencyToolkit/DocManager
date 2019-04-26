# API calls for querying the dataspec in elasticsearch
class DataspecController < ApplicationController
  include RetrieveDataspec
  include ModifyDatasource
  include LoadDataspec
  include IndexManager
  
  # Save the settings for newly created archive
  def create_archive
    archive_config = params["archive_config_json"]
    project = create_project_from_archive_admin(archive_config)
    create_index(project.index_name, project, Elasticsearch::Model.client)
  end

  # Update the archive settings
  def update_archive
    archive_config = params["archive_config_json"]
    project_index = params["index_name"]
    found_project = Project.where(index_name: project_index).first
    update_project_from_archive_admin(archive_config, found_project)
  end
  
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
