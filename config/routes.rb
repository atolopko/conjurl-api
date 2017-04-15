Rails.application.routes.draw do

  get "/:short_url_key", to: "short_url_redirect#redirect"
  
  namespace :api do
    post '/short_urls', to: 'short_urls#create'
    get  '/short_urls/:short_url_key', to: 'short_urls#index'
    get  '/short_urls/:short_url_key/statistics', to: 'short_urls#statistics'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
