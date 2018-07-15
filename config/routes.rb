Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'game' => 'games#show', via: :get
  match 'game' => 'games#create', via: :post
  match 'move' => 'games#move', via: :post
end
