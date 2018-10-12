Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users do
    get 'bank_accounts/show'
  end
  root to: 'bank_accounts#show'
end
