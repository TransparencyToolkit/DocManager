require "socket"

# API calls for creating, updating, and deleting in the elasticsearch index
class IndexController < ApplicationController
  include CreateUpdateDelete
  
  # Add new items via API call
  def add_items
    # Process params
    item_type = params["item_type"]
    index_name = params["index_name"]
    items = JSON.parse(params["items"])
    
    # Index the data
    render json: create_items(items, index_name, item_type)
  end

  # Remove items from elastic
  def remove_items
    delete_items_from_elastic(JSON.parse(params["items"]))
  end
end
