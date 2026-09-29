class Volunteers::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:volunteer).permit(:email, :password, :password_confirmation, :name, :surname, :skill, :interest)
  end

  def account_update_params
    params.require(:volunteer).permit(:email, :password, :password_confirmation, :current_password, :name, :surname, :skill, :interest)
  end
end