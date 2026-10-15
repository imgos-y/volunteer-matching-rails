Rails.application.routes.draw do
  resource :session, only: :destroy
  resources :passwords, param: :token
  resources :events, only: [ :index, :new, :create ] do
    member do
      patch :cancel
    end

    resource :event_registration, only: [ :create ], controller: "event_registrations"
    resources :event_feedbacks, only: [ :create ]
  end

  resources :notifications, only: [ :index ] do
    member { patch :mark_as_read }
  end

  resources :badges, only: [ :index, :new, :create ]

  delete "events/:event_id/registration", to: "event_registrations#cancel", as: :cancel_event_registration
  patch "events/:event_id/registrations/:id/confirm_attendance", to: "event_registrations#confirm_attendance", as: :confirm_attendance
  patch "events/:event_id/registrations/:id/mark_no_show", to: "event_registrations#mark_no_show", as: :mark_no_show

  get "volunteer/my_events", to: "volunteers#my_events", as: :my_events

  get "volunteer/points", to: "volunteers#points", as: :volunteer_points
  get "volunteer/profile", to: "volunteers#profile", as: :volunteer_profile


  get "organizer/profile", to: "organizers#profile", as: :organizer_profile
  get "organizer/dashboard", to: "organizers#dashboard", as: :organizer_dashboard
  get "organizer/feedbacks", to: "organizers#feedbacks", as: :organizer_feedbacks
  get "home/index"

  namespace :volunteers do
    resource :session, only: %i[new create]
    resource :registration, only: %i[new create edit update]
  end

  namespace :organizers do
    resource :session, only: %i[ new create ]
    resource :registration, only: %i[ new create edit update ]
  end


  get "up" => "rails/health#show", as: :rails_health_check


  root to: "home#index"
end
