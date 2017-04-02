Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'add_items' => 'index#add_items', as: :index_add_items, via: [:get, :post]
end
