class Admin::DashboardController < ApplicationController
  before_filter :authorize_admin

  def join_requests
    # Requests that need to be reviewed
    @memberships = UserMembership.where(admin_approved: false)

    # Courses where someone needs to be approved
    @courses = @memberships.map { |m| m.course }.compact.uniq { |c| c.id }
  end

  # WARNING: this is slow so...
  # TODO: Optimize
  def demographics
    # Users who have had the maximum 3 attempts of the quiz OR Passed
    membership_ids = UserMembership.all.map { |membership|
      if membership.didUserPassCourse? || 
         membership.course_attempts == 3
        membership.id
      end
    }.compact.uniq

    memberships_temp = UserMembership.find(membership_ids)
    course_ids = memberships_temp.map { |m| m.course.id }.compact.uniq

    @courses = Course.where(id: course_ids)
    @memberships = UserMembership.where(id: membership_ids)

    respond_to do |format|
      format.html
      format.csv { send_data (@memberships.to_csv + @courses.to_csv) }
    end
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
    @courses = @memberships.map { |m| m.course }.compact.uniq { |c| c.id }
  end
end
