class Organizers::RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :require_organizer, only: %i[ edit update ]

  def new
    @organizer = Organizer.new
    @organizer.build_user
  end

  def create
    @organizer = Organizer.new(organizer_params)

    if @organizer.save
      start_new_session_for @organizer.user
      redirect_to organizer_dashboard_path, notice: "Welcome! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @organizer = current_organizer
  end

  def update
    @organizer = current_organizer

    if @organizer.update(organizer_params)
      redirect_to organizer_profile_path, notice: "Your profile has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def organizer_params
    params.expect(organizer: [ :name,
                               user_attributes: [ :email_address, :password, :password_confirmation, :password_challenge ] ])
  end
end
