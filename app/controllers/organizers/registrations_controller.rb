class Organizers::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:organizer).permit(:email, :password, :password_confirmation, :name, :surname)
  end

  def account_update_params
    params.require(:organizer).permit(:email, :password, :password_confirmation, :current_password, :name, :surname)
  end
end