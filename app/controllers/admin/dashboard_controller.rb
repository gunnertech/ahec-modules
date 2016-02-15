class Admin::DashboardController < ApplicationController
  before_filter :authorize_admin

  def join_requests
    # Requests that need to be reviewed
    @memberships = UserMembership.where(admin_approved: false)

    # Courses where someone needs to be approved
    @courses = @memberships.map { |m| m.course }.uniq { |c| c.id }
  end

  def approve_member
    if params[:id]
      membership = UserMembership.find_by_id(params[:id])

      if membership
        membership.admin_approved = true
        membership.save
      end
    end

    redirect_to admin_join_requests_path
  end

  def display_passed_users
    # Requests that need to be reviewed
    @memberships = UserMembership.all.select { |m| m.didUserPassCourse? }

    # Courses where someone needs to be approved
    @courses = @memberships.map { |m| m.course }.uniq { |c| c.id }
  end
end
