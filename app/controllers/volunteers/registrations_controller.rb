class Volunteers::RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :require_volunteer, only: %i[ edit update ]

  def new
    @volunteer = Volunteer.new
    @volunteer.build_user
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      start_new_session_for @volunteer.user
      redirect_to events_path, notice: "Welcome! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @volunteer = current_volunteer
  end

  def update
    @volunteer = current_volunteer

    if @volunteer.update(volunteer_params)
      redirect_to volunteer_profile_path, notice: "Your profile has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def volunteer_params
    params.expect(volunteer: [ :name, :surname, :skill, :interest,
                               user_attributes: [ :email_address, :password, :password_confirmation, :password_challenge ] ])
  end
end
