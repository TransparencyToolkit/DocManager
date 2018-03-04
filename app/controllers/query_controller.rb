# API calls for querying the documents in elasticsearch
class QueryController < ApplicationController
  include BasicLoad
  include CountQueries
  include RunSearchQuery
end
