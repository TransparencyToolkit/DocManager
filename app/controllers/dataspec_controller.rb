# API calls for querying the dataspec in elasticsearch
class DataspecController < ApplicationController
  skip_before_action :verify_authenticity_token
  include RetrieveDataspec
end
