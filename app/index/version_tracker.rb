# Tracks versions of the document
module VersionTracker
  # Track the versions of the document
  def track_versions(doc, doc_class, datasource)
    # Get doc if it exists
    if doc_class.exists?(doc[:id])
      client = doc_class.__elasticsearch__.client
      already_indexed_doc = client.get({ index: doc_class.index_name, id: doc[:id] })["_source"].symbolize_keys
    end
    
    # Add version tracking info
    versioned = append_version_to_list(already_indexed_doc, doc, datasource)
    
    # Replace overall doc with more recent version if needed and return
    most_recent = unindexed_doc_more_recent?(already_indexed_doc, doc, datasource) ? (versioned.merge!(doc)) : (versioned)
    return merge_tags_across_versions(most_recent, datasource)
  end

  # Merge the collection and selector tags across versions of the doc
  def merge_tags_across_versions(doc, datasource)
    # Get a list of categories where values should be merged across versions
    categories_to_merge = datasource.categories_to_merge_across_versions
    empty_merge_tags_hash = categories_to_merge.map{|c| [c, []]}.to_h if categories_to_merge
    
    # Get all the collection and selector tags
    merged_tag_fields = doc[:doc_versions].inject(empty_merge_tags_hash) do  |tags, version|
      tags.each do |tag, value|
        # Merge each tag into one array
        if version[tag]
          tags[tag] = (tags[tag] | version[tag].to_a) if version[tag].is_a?(Array)
          tags[tag] = (tags[tag] | [version[tag]]) if version[tag].is_a?(String)
        end
      end
      tags
    end
    
    # Merge vaues with doc
    doc.symbolize_keys.merge(merged_tag_fields.symbolize_keys)
  end

  # Check if the unindexed document is more recent
  def unindexed_doc_more_recent?(already_indexed, unindexed, datasource)
    if already_indexed && unindexed[datasource.most_recent_timestamp] && already_indexed[datasource.most_recent_timestamp]
      return unindexed[datasource.most_recent_timestamp].to_date >= already_indexed[datasource.most_recent_timestamp].to_date
    else
      return true
    end
  end

  # Add version to version lists
  def append_version_to_list(original_doc, new_doc, datasource)
    # No doc exists yet, initialize with this version
    if original_doc == nil
      return new_doc.merge({versions_list: [new_doc[datasource.most_recent_timestamp]],
                    doc_versions: [new_doc],
                    version_changed: set_changed_field(original_doc, new_doc, nil, datasource)})
      
    else # Doc exists, check if changed and add version info
      doc_versions = original_doc[:doc_versions].push(new_doc)
      return original_doc.to_hash.except(:created_at, :updated_at)
             .merge({versions_list: original_doc[:versions_list].push(new_doc[datasource.most_recent_timestamp]),
                     doc_versions: doc_versions,
                     version_changed: set_changed_field(original_doc, new_doc, doc_versions, datasource)}).to_hash
    end
  end

  # Set the value of the change list
  def set_changed_field(original_doc, new_doc, doc_versions, datasource)
    # Keep preset value
    if new_doc["version_changed"]
      return new_doc["version_changed"]

    # Set value for unchanged
    elsif original_doc == nil && new_doc
      return "Not Changed"
      
    else # Doc already indexed, check if it changed
      return check_if_changed(doc_versions, datasource, original_doc)
    end
  end

  # Check if a field was added in a later version
  def field_added_in_later_version?(version_times, just_fields_to_track)
    # Label each version with a corresponding time and remove blank fields
    version_times = version_times.map{|t| Date.parse(t.to_s)}
    without_blank_fields = Array.new
    just_fields_to_track.each_with_index do |version, i|
      without_blank_fields.push(version.select{|k, v| !v.blank?}.merge({vtime: version_times[i]}))
    end

    # Check if there are different #s of fields
    if without_blank_fields.map{|item| item.keys}.uniq.length > 1
      sorted = without_blank_fields.sort_by{|item| item[:vtime]}
      return true if sorted.first.keys.length < sorted.last.keys.length
    end

    return false
  end

  # Check if the doc is changed across versions
  def check_if_changed(doc_versions, datasource, original_doc)
    # Get only the fields specified to track in the dataspec
    just_fields_to_track = doc_versions.map do |doc|
      selected = doc.select{|field| datasource.fields_to_track.include?(field)}
      selected.map{|k, v| [k, v.to_s.gsub(/[^0-9a-z]/i, "")]}.to_h
    end

    # Check if the values are changed
    if just_fields_to_track.uniq.length == 1
      return "Not Changed"
    elsif field_added_in_later_version?(doc_versions.map{|i| i["timestamp"]}, just_fields_to_track)
      return "Not Changed"
    else
      return "Changed"
    end
  end
end
