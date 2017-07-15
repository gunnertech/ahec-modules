class Admin::DashboardController < ApplicationController
  before_filter :authorize_admin

  def reset_user
  end

  def reset_user_attempts
    user = User.where(email: params[:email])

    if user.size < 1
      redirect_to admin_user_reset_path, :flash => { :error => "User with that email does not exist!" }
      return
    end

    user = user.first
    membership = UserMembership.where(user_id: user.id, course_id: (params[:course_id] || -1))

    if membership.size < 1
      redirect_to admin_user_reset_path, :flash => { :error => "User has not registered for that course" }
      return
    end

    membership = membership.first
    membership.course_attempts = 0
    membership.save

    redirect_to admin_user_reset_path, :flash => { :success => "User attempts successfully reset" }
  end

  def join_requests
    # Requests that need to be reviewed
    @memberships = UserMembership.where(admin_approved: false)

    # Courses where someone needs to be approved
    @courses = @memberships.map { |m| m.course }.compact.uniq { |c| c.id }
  end

  def generate_demographics_csv(courses, memberships)
    CSV.generate do |csv|
      courses.sort_by { |m| m.title }.each do |course|
        csv << [
          course.title.to_s,
          ("Minimum Passing Grade: " + course.minimum_score.to_s),
          ("Minimum Time: " + course.minimum_time_spent.to_s)
        ]
        csv << [
          '',
          'Name',
          'Email',
          'Profession',
          'Address',
          'City',
          'State',
          'Zip',
          'NABP #',
          'Professional Licenses',
          'Date of Birth',
          'Last 4 of Social',
          'Personal Phone',
          'Employer Name',
          'Employer Phone',
          'Employer Address',
          'Employer State',
          'Employer City',
          'Employer Zip',
          'Pre-Test Score',
          'Latest Test Score',
          'Attempts',
          'Time Completed At',
          'Minutes Spent'
        ]

        (@memberships.select { |m| m.course_id == course.id }.sort_by { |m| m.id }).each do |membership|
          csv << [
            '',
            membership.user.getDisplayName,
            membership.user.email,
            membership.user.profession,
            membership.user.address,
            membership.user.city,
            membership.user.state,
            membership.user.zip_code,
            membership.user.nabp_id,
            membership.user.professional_licenses,
            membership.user.dob,
            membership.user.social_security,
            membership.user.personal_phone,
            membership.user.employer,
            membership.user.employer_phone,
            membership.user.employer_address,
            membership.user.employer_state,
            membership.user.employer_city,
            membership.user.employer_zip,
            membership.pretest_grade,
            membership.course_grade,
            membership.course_attempts,
            membership.passed_on,
            membership.minutes_spent
          ]
        end

        csv << []
      end
    end
  end

  # Note: With the addition of survey_responses this may be optimizable
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
      format.csv { render text: generate_demographics_csv(@courses, @memberships) }
    end
  end

  def survey_responses
    @memberships = UserMembership.where.not(special_questions_responses: nil)
    @courses = Course.where(id: @memberships.map { |m| m.course.id }.compact.uniq)

    respond_to do |format|
      format.html
      format.csv { render text: generate_survey_responses_csv(@memberships, @courses) }
    end
  end

  def generate_survey_responses_csv(memberships, courses)
    CSV.generate do |csv|
      courses.sort_by { |m| m.title }.each do |course|
        csv << [
          course.title.to_s,
          ("Questions: " + course.special_questions.to_s)
        ]
        csv << [
          '',
          'Name',
          'Email',
          'Responses'
        ]

        (@memberships.select { |m| m.course_id == course.id }.sort_by { |m| m.id }).each do |membership|
          csv << [
            '',
            membership.user.getDisplayName,
            membership.user.email,
            JSON.parse(membership.special_questions_responses).map { |response| response[1] }
          ]
        end

        csv << []
      end
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
