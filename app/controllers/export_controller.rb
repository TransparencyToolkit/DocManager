# Controller and API for exporting data
class ExportController < ApplicationController
  include RunQuery
  include QueryBuilder
  include RetrieveDataspec
  
  # Export data
  def export_to_public
    set_instance_vars

    # Get documents to export
    docs = query_docs("docs_to_export", params["date_changed_since"], params["pub_selector_field"],
                      JSON.parse(params["acceptable_to_publish_values"]), params["doc_type"])
    filtered_docs = filter_documents(docs)

    # Filter dataspec and project spec
    filtered_dataspec = filter_dataspec
    filtered_projectspec = filter_projectspec
    save_filtered(filtered_docs, filtered_dataspec, filtered_projectspec)
    sync_exported_data
  end

  private

  # Sync the exported data
  def sync_exported_data
    begin
      # Sync json data and config
      Rsync.run("#{ENV['SAVE_EXPORT_PATH']}/json_docs/", ENV['SYNC_JSONDATA_PATH'], "-r -e 'ssh -i /tt-config/id_ed25519'")
      Rsync.run("#{ENV['SAVE_EXPORT_PATH']}/dataspec_files/", ENV['SYNC_CONFIG_PATH'], "-r e 'ssh -i /tt-config/id_ed25519'")
      
      # Sync the attachments (preserving the path/directories- best with same path on both)
      @attachments_to_export.each do |raw_file|
        Rsync.run(raw_file, ENV['SYNC_RAWDOC_PATH'], "-R e 'ssh -i /tt-config/id_ed25519'")
      end
    rescue # Retry if it rails to sync
      sleep(5)
      sync_exported_data
    end
  end
  
  # Save the filtered docs, dataspec, projectspec
  def save_filtered(docs, dataspec, project)
    # Create directories as needed
    FileUtils.mkdir_p("#{ENV['SAVE_EXPORT_PATH']}/json_docs")
    #FileUtils.mkdir_p("#{ENV['SAVE_EXPORT_PATH']}/attachments_to_export")
    FileUtils.mkdir_p("#{ENV['SAVE_EXPORT_PATH']}/dataspec_files/projects")
    FileUtils.mkdir_p("#{ENV['SAVE_EXPORT_PATH']}/dataspec_files/data_sources")

    # Save documents and list of attachments
    doc_save_path = "#{ENV['SAVE_EXPORT_PATH']}/json_docs/#{Time.now.to_s.gsub(" ", "_").gsub(":", "-")}_#{params["doc_type"]}.json"
    File.write(doc_save_path, JSON.pretty_generate(docs))
    @attachments_to_export = get_attachments_to_publish(docs, dataspec)

    # Save dataspecs and project specs
    dataspec_save_path = "#{ENV['SAVE_EXPORT_PATH']}/dataspec_files/data_sources/#{params['doc_type'].underscore}.json"
    File.write(dataspec_save_path, JSON.pretty_generate(dataspec))
    project_save_path = "#{ENV['SAVE_EXPORT_PATH']}/dataspec_files/projects/#{@index_name}.json"
    File.write(project_save_path, JSON.pretty_generate(project))
  end

  # Get a list of the attachments to publish
  def get_attachments_to_publish(docs, dataspec)
    # Get the fields of attachment type
    attachment_types = ["Attachment", "Email Attachment", "Picture"]
    attachment_fields = dataspec[:fields].to_a.select{|field| attachment_types.include?(field[1]["display_type"])}.map{|f| f[0]}

    # Get the paths of attachments to export
    return docs.map{|doc| doc.slice(*attachment_fields).values}.flatten.uniq
  end

  # Filter the documents to export
  def filter_documents(docs)
    filtered_docs_to_export = docs.map do |doc|
      filtered = doc["_source"].slice(*@allowed_fields)
      filtered[:index_fields] = { index_name: @index_name, item_type: params["doc_type"] }
      filtered
    end
  end

  # Filter the dataspec
  def filter_dataspec
    # Filter dataspec for fields to export
    dataspec = get_dataspec_for_project_source(@index_name, params["doc_type"])

    # Save in correct format to export
    dataspec_hash = {
      data_source_details: {
        name: dataspec.name,
        description: dataspec.description,
        icon: dataspec.icon,
        input_params: dataspec.input_params
      },
      index_details: {
        mapping: dataspec.mapping,
        class_name: dataspec.class_name
      },
      view_details: {
        show_tabs: dataspec.show_tabs,
        results_template: dataspec.results_template
      },
      sort_details: {
        sort_field: dataspec.sort_field,
        sort_order: dataspec.sort_order,
        thread_id_field: dataspec.thread_id_field,
        never_item_fields: dataspec.never_item_fields
      },
      id_details: {
        id_field: dataspec.id_field,
        secondary_id: dataspec.secondary_id,
        trim_from_id: dataspec.trim_from_id
      },
      version_tracking_details: {
        fields_to_track: dataspec.fields_to_track,
        most_recent_timestamp: dataspec.most_recent_timestamp,
        categories_to_merge_across_versions: dataspec.categories_to_merge_across_versions
      },
      fields: dataspec.source_fields.slice(*@allowed_fields)
    }
  end

  # Filter the project spec
  def filter_projectspec
    # Get project to export
    project = get_project(@index_name)

    # Save in correct format to export
    project_hash = {
      display_details: {
        title: project.title,
        theme: project.theme,
        favicon: project.favicon,
        logo: project.logo,
        info_links: project.info_links.to_h,
        other_topbar_links: project.other_topbar_links.to_h
      },
      data_source_details: project.datasources.map{|source| "dataspec_files/data_sources/#{source.class_name.underscore}.json" },
      index_name: project.index_name
    }
  end

  def set_instance_vars
    @index_name = params["index_name"]
    @allowed_fields = JSON.parse(params["fields_to_include_in_export"])
  end
end
