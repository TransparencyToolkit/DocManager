# API calls for creating, updating, and deleting in the elasticsearch index
class IndexController < ApplicationController
  include CreateUpdateDelete
  skip_before_action :verify_authenticity_token

  # Add new items via API call
  def add_items
    # Process params
    item_type = params["item_type"]
    index_name = params["index_name"]
    items = JSON.parse(params["items"])
    
    # Index the data
    create_items(items, index_name, item_type)
  end
end
