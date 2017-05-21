module RemoveItems
  # Go through the items for the collection or selector and delete them
  def remove_items
    # Get the models and tag info
    models = get_all_models_for_project(params["index_name"])
    collection = [params["collection"]]
    selectors = JSON.parse(params["selectors"])

    # Get all the matching items
    items = Elasticsearch::Model.search({from: 0, size: 99999999, query:
                                         { bool: {filter: [
                                                    {
                                                      terms:
                                                        {"collection_tag.keyword" => collection }
                                                    }, {
                                                      terms:
                                                        {"selector_tag.keyword" => selectors}
                                                    }]}}}, models).response["hits"]["hits"]

    # Delete the items or remove the tags
    if !items.blank?
      datasource = get_dataspec_for_project_source(items.first["_index"], items.first["_type"].gsub(items.first["_index"],"").camelize)
      delete_items_from_elastic(remove_tags(items, collection, selectors, datasource))
    end
  end

  # Remove the tags if needed
  def remove_tags(items, collection, selectors, datasource)
    # Remove collection and selectors from overall doc
    processed_items = items.map do |item|
      item["_source"]["collection_tag"] -= collection
      item["_source"]["selector_tag"] -= selectors
      item
    end

    # Get the versions of the items to remove
    versions_removed = processed_items.map do |item|
      # Get the versions to remove
      doc_version_to_remove = item["_source"]["doc_versions"].select do |version|
        !(version["collection_tag"] & collection).blank? && !(version["selector_tag"] & selectors).blank?
      end
      version_time_list = doc_version_to_remove.map{|version| Date.parse(version[datasource.most_recent_timestamp]).to_s}
      
      # Remove the versions
      item["_source"]["doc_versions"] -= doc_version_to_remove
      item["_source"]["versions_list"] -= version_time_list
      item
    end

    # Update if there are some terms left, otherwise delete them
    to_update = versions_removed.select{|item| !item["_source"]["doc_versions"].empty?}
    update_items_to_remove_tags(to_update)
    return (versions_removed-to_update)
  end

  # Update the items to remove the tags
  def update_items_to_remove_tags(items)
    items.map{|i| {id: i["_id"], type: i["_type"], index: i["_index"], body: {doc: i["_source"]}}}.each do |item|
      Elasticsearch::Model.client.update item
    end
  end

  # Delete all the items passed in from elastic
  def delete_items_from_elastic(items)
    items.map{|i| {id: i["_id"], type: i["_type"], index: i["_index"]}}.each do |item|
      Elasticsearch::Model.client.delete item
    end
  end
end
