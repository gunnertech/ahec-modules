class Users::UserMembershipController < ApplicationController
  def get_passed_courses_certificates
    @courses = current_user.get_passed_courses
    render 'devise/certificates_list'
  end
end
