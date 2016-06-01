class Users::RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :profession, :dob, :nabp_id, :professional_licenses, :city, :state, :zip_code, :address, :email, :password, :password_confirmation, :current_password, :social_security, :personal_phone, :employer, :employer_address, :employer_state, :employer_city, :employer_zip, :employer_phone)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :profession, :nabp_id, :professional_licenses, :city, :state, :zip_code, :address, :email, :password, :password_confirmation, :current_password, :personal_phone, :employer, :employer_address, :employer_state, :employer_city, :employer_zip, :employer_phone)
  end
end
