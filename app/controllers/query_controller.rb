# API calls for querying the documents in elasticsearch
class QueryController < ApplicationController
  skip_before_action :verify_authenticity_token
  include BasicLoad
  include CountQueries
end
