# Tracks versions of the document
module VersionTracker
  # Track the versions of the document
  def track_versions(doc, doc_class, datasource)
    # Get doc if it exists
    already_indexed_doc = doc_class.find(doc[:id]) if doc_class.exists?(doc[:id])

    # Add version tracking info
    versioned = append_version_to_list(already_indexed_doc, doc, datasource)
   
    # Replace overall doc with more recent version if needed and return
    most_recent = unindexed_doc_more_recent?(already_indexed_doc, doc, datasource) ? (versioned.merge!(doc)) : (versioned)
    return merge_tags_across_versions(most_recent)
  end

  # Merge the collection and selector tags across versions of the doc
  def merge_tags_across_versions(doc)
    # Get all the collection and selector tags
    merged_tag_fields = doc[:doc_versions].inject({collection_tag: [], selector_tag: []}) do  |tags, version|
      tags[:collection_tag] = (tags[:collection_tag] | version["collection_tag"].to_a)
      tags[:selector_tag] = (tags[:selector_tag] | version["selector_tag"].to_a)
      tags
    end

    # Merge vaues with doc
    doc.symbolize_keys.merge(merged_tag_fields)
  end

  # Check if the unindexed document is more recent
  def unindexed_doc_more_recent?(already_indexed, unindexed, datasource)
    if already_indexed
      return unindexed[datasource.most_recent_timestamp].to_date > already_indexed[datasource.most_recent_timestamp].to_date
    end
  end

  # Add version to version lists
  def append_version_to_list(original_doc, new_doc, datasource)
    # No doc exists yet, initialize with this version
    if original_doc == nil
      return new_doc.merge({versions_list: [new_doc[datasource.most_recent_timestamp]],
                    doc_versions: [new_doc],
                    version_changed: "Not Changed"})
      
    else # Doc exists, check if changed and add version info
      doc_versions = original_doc[:doc_versions].push(new_doc)
      return original_doc.to_hash.except(:created_at, :updated_at)
             .merge({versions_list: original_doc[:versions_list].push(new_doc[datasource.most_recent_timestamp]),
                     doc_versions: doc_versions,
                     version_changed: check_if_changed(doc_versions, datasource)}).to_hash
    end
  end

  # Check if the doc is changed across versions
  def check_if_changed(doc_versions, datasource)
    # Get only the fields specified to track in the dataspec
    just_fields_to_track = doc_versions.map{|doc| doc.select{|field| datasource.fields_to_track.include?(field)}}

    # Check if the values are changed
    just_fields_to_track.uniq.length == 1 ? (return "Not Changed") : (return "Changed")
  end
end
