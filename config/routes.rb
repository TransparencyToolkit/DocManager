Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'add_items' => 'index#add_items', as: :index_add_items, via: [:get, :post]
  match 'get_docs_on_index_page' => 'query#get_docs_on_index_page', as: :query_get_docs_on_index_page, via: [:get, :post]
  match 'get_total_docs' => 'query#get_total_docs', as: :query_get_total_docs, via: [:get, :post]
  match 'get_dataspec_for_doc' => 'dataspec#get_dataspec_for_doc2', as: :dataspec_get_dataspec_for_doc, via: [:get, :post]
  match 'get_project_spec' => 'dataspec#get_project_spec2', as: :dataspec_get_project_spec, via: [:get, :post]
  match 'get_facet_details_for_project' => 'dataspec#get_facet_details_for_project2', as: :dataspec_get_facet_details_for_project, via: [:get, :post]
  match 'get_dataspecs_for_project' => 'dataspec#get_dataspecs_for_project2', as: :dataspec_get_dataspecs_for_project, via: [:get, :post]
  match 'run_query' => 'query#run_query', as: :query_run_query, via: [:get, :post]
  match 'get_doc' => 'query#get_doc', as: :query_get_doc, via: [:get, :post]
end
