# API calls for querying the dataspec in elasticsearch
class DataspecController < ApplicationController
  skip_before_action :verify_authenticity_token
  include RetrieveDataspec
  
  def get_facet_details_for_project2
    get_facet_details_for_project
  end

  def get_project_spec2
    get_project_spec
  end

  def get_dataspec_for_doc2
    get_dataspec_for_doc
  end

  def get_dataspecs_for_project2
    get_dataspecs_for_project
  end
  
end
