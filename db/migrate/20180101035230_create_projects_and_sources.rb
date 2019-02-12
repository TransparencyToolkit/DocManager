class CreateProjectsAndSources < ActiveRecord::Migration[5.1]
  def up
    enable_extension 'hstore' unless extension_enabled?('hstore')

    create_table :recipes do |t|
      t.belongs_to :project, index: true
      t.string :title
      t.hstore :docs_to_process
      t.string :index_name
      t.string :doc_type
    end
    
    create_table :annotators do |t|
      t.belongs_to :recipe, index: true
      t.string :annotator_class
      t.string :human_readable_label
      t.string :icon
      t.text :fields_to_check, array: true
      t.hstore :annotator_options
    end
    
    create_table :projects do |t|
      t.hstore :project_config
      t.string :index_name
      t.hstore :datasources
      t.string :title
      t.string :theme
      t.string :favicon
      t.string :logo
      t.hstore :other_topbar_links
      t.hstore :info_links
      t.text :front_page_documents, array: true
    end

    create_table :datasources do |t|
      t.belongs_to :project, index: true
      t.hstore :source_config
      t.string :name
      t.string :description
      t.string :icon
      t.hstore :input_params
      t.string :mapping
      t.string :class_name
      t.string :sort_field
      t.string :sort_order
      t.string :thread_id_field
      t.text :never_item_fields, array: true
      t.text :show_tabs, array: true
      t.string :results_template
      t.string :id_field
      t.text :secondary_id, array: true
      t.text :trim_from_id, array: true
      t.text :fields_to_track, array: true
      t.text :categories_to_merge_across_versions, array: true
      t.string :most_recent_timestamp
      t.json :source_fields
    end
  end

  def down
    drop_table :projects
    drop_table :datasources
  end
end
