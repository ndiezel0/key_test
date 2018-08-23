Rails.application.routes.draw do
  root 'home#index'
  post '/search', to: 'home#search', as: :search_offer
  get '/imports', to: 'import#imports', as: :imports
  post '/import_shops', to: 'import#import', as: :import_shops
  get '/items/:id', to: 'items#item', as: :item
end
