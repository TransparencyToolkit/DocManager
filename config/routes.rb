Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'add_items' => 'index#add_items', as: :index_add_items, via: [:get, :post]
  match 'remove_items' => 'index#remove_items', as: :index_remove_items, via: [:get, :post]
  match 'get_docs_on_index_page' => 'query#get_docs_on_index_page', as: :query_get_docs_on_index_page, via: [:get, :post]
  match 'get_total_docs' => 'query#get_total_docs', as: :query_get_total_docs, via: [:get, :post]
  match 'get_total_doc_count_for_type' => 'query#get_total_doc_count_for_type', as: :query_get_total_doc_count_for_type, via: [:get, :post]
  match 'get_collection_doc_total' => 'query#get_collection_doc_total', as: :query_get_collection_doc_total, via: [:get, :post]
  match 'get_dataspec_for_doc' => 'dataspec#get_dataspec_for_doc', as: :dataspec_get_dataspec_for_doc, via: [:get, :post]
  match 'get_project_spec' => 'dataspec#get_project_spec', as: :dataspec_get_project_spec, via: [:get, :post]
  match 'add_field' => 'dataspec#add_field', as: :dataspec_add_field, via: [:post]
  match 'remove_field' => 'dataspec#remove_field', as: :dataspec_remove_field, via: [:post]
  match 'get_facet_details_for_project' => 'dataspec#get_facet_details_for_project', as: :dataspec_get_facet_details_for_project, via: [:get, :post]
  match 'get_dataspecs_for_project' => 'dataspec#get_dataspecs_for_project', as: :dataspec_get_dataspecs_for_project, via: [:get, :post]
  match 'get_facet_list_divided_by_source' => 'dataspec#get_facet_list_divided_by_source', as: :dataspec_get_facet_list_divided_by_source, via: [:get, :post]
  match 'run_query' => 'query#run_search_query', as: :query_run_query, via: [:get, :post]
  match 'run_query_catalyst' => 'query#run_query_catalyst', as: :query_run_query_catalyst, via: [:get, :post]
  match 'run_query_catalyst_count' => 'query#run_query_catalyst_count', as: :query_run_query_catalyst_count, via: [:get, :post]
  match 'run_range_query_catalyst' => 'query#run_range_query_catalyst', as: :query_run_range_query_catalyst, via: [:get, :post]
  match 'run_range_query_catalyst_count' => 'query#run_range_query_catalyst_count', as: :query_run_range_query_catalyst_count, via: [:get, :post]
  match 'get_doc' => 'query#get_doc', as: :query_get_doc, via: [:get, :post]
  match 'get_docs_in_thread' => 'query#get_docs_in_thread', as: :query_get_docs_in_thread, via: [:get, :post]
  match 'get_all_docs' => 'query#get_all_docs', as: :query_get_all_docs, via: [:get, :post]
  match 'get_nil_docs' => 'query#get_nil_docs', as: :query_get_nil_docs, via: [:get, :post]
  match 'get_term_vector' => 'query#get_term_vector', as: :query_get_term_vector, via: [:get, :post]
  match 'get_child_documents' => 'query#get_child_documents', as: :query_get_child_documents, via: [:get, :post]

  # Catalyst methods
  match 'create_recipe' => 'recipe#create_recipe', as: :recipe_create_recipe, via: [:post]
  match 'create_annotator' => 'annotator#create_annotator', as: :annotator_create_annotator, via: [:post]
  match 'get_recipes_for_index' => 'recipe#get_recipes_for_index', as: :recipe_get_recipes_for_index, via: [:get]
  match 'get_annotators_for_recipe' => 'annotator#get_annotators_for_recipe', as: :annotator_get_annotators_for_recipe, via: [:get]
  match 'run_recipe' => 'recipe#run_recipe', as: :recipe_run_recipe, via: [:get]
  match 'update_recipe' => 'recipe#update_recipe', as: :recipe_update_recipe, via: [:post]
  match 'update_annotator' => 'annotator#update_annotator', as: :annotator_update_annotator, via: [:post]
  match 'destroy_recipe' => 'recipe#destroy_recipe', as: :recipe_destroy_recipe, via: [:post]
  match 'destroy_annotator' => 'annotator#destroy_annotator', as: :annotator_destroy_annotator, via: [:post]
end
