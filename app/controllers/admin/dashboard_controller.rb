class Admin::DashboardController < ApplicationController
  before_filter :authorize_admin

  def join_requests
    # Requests that need to be reviewed
    @memberships = UserMembership.where(admin_approved: false)

    # Courses where someone needs to be approved
    @courses = @memberships.map { |m| m.course }.uniq { |c| c.id }
  end

  # WARNING: this is slow so...
  # TODO: Optimize
  def demographics
    # Users who have had the maximum 3 attempts of the quiz OR Passed
    @memberships = UserMembership.all.map { |membership|
      if membership.didUserPassCourse? || 
         membership.course_attempts == 3
        membership
      end
    }.compact.uniq { |m| m.id }

    @courses = @memberships.map { |m| m.course }.compact.uniq { |c| c.id }
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
