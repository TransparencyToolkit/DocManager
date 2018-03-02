class CreateProjectsAndSources < ActiveRecord::Migration[5.1]
  def up
    enable_extension 'hstore' unless extension_enabled?('hstore')
    
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
      t.text :show_tabs, array: true
      t.string :results_template
      t.string :id_field
      t.text :secondary_id, array: true
      t.text :trim_from_id, array: true
      t.text :fields_to_track, array: true
      t.string :most_recent_timestamp
      t.json :source_fields
    end
  end

  def down
    drop_table :projects
    drop_table :datasources
  end
end
