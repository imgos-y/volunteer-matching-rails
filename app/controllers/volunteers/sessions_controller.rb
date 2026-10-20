class Volunteers::SessionsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_volunteers_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.volunteers.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Signed in successfully."
    else
      redirect_to new_volunteers_session_path, alert: "Invalid email or password."
    end
  end
end
