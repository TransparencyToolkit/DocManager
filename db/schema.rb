# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_01_01_035230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "annotators", force: :cascade do |t|
    t.bigint "recipe_id"
    t.string "annotator_class"
    t.string "human_readable_label"
    t.string "icon"
    t.text "fields_to_check", array: true
    t.hstore "annotator_options"
    t.index ["recipe_id"], name: "index_annotators_on_recipe_id"
  end

  create_table "datasources", force: :cascade do |t|
    t.bigint "project_id"
    t.hstore "source_config"
    t.string "name"
    t.string "description"
    t.string "icon"
    t.hstore "input_params"
    t.string "mapping"
    t.string "class_name"
    t.string "sort_field"
    t.string "sort_order"
    t.string "thread_id_field"
    t.text "never_item_fields", array: true
    t.text "show_tabs", array: true
    t.string "results_template"
    t.string "id_field"
    t.text "secondary_id", array: true
    t.text "trim_from_id", array: true
    t.text "fields_to_track", array: true
    t.text "categories_to_merge_across_versions", array: true
    t.string "most_recent_timestamp"
    t.json "source_fields"
    t.index ["project_id"], name: "index_datasources_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.hstore "project_config"
    t.string "index_name"
    t.hstore "datasources"
    t.string "title"
    t.string "theme"
    t.string "favicon"
    t.string "logo"
    t.hstore "other_topbar_links"
    t.hstore "info_links"
    t.text "front_page_documents", array: true
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "project_id"
    t.string "title"
    t.hstore "docs_to_process"
    t.string "index_name"
    t.string "doc_type"
    t.index ["project_id"], name: "index_recipes_on_project_id"
  end

end
