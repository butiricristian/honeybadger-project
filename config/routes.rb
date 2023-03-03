Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope "/api/v1" do
    post 'notifications/check-spam', to: 'notifications#check_spam'
  end
end
