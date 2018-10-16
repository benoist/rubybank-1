Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => {
    sessions: 'devise/sessions'
  }
  get 'transfers/new', controller: :transfers, action: :new
  post 'transfers', controller: :transfers, action: :create
  root to: 'bank_accounts#show'
end
