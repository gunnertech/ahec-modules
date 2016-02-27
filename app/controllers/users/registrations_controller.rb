class Users::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :profession, :dob, :nabp_id, :city, :state, :zip_code, :address, :email, :password, :password_confirmation, :current_password)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :profession, :dob, :nabp_id, :city, :state, :zip_code, :address, :email, :password, :password_confirmation, :current_password)
  end
end
