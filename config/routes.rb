Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :account, only: :show, controller: :account
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Themed default page (frontend-swap reference; superceded by the layout in 06).
  root "pages#home"

  # Component previews are development-only surfaces: never route/mount them in
  # production. Lookbook is only in the :development bundle, so referencing the
  # engine here is safe and stays inert in test (which draws these routes).
  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
end
