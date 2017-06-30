class CoursesController < ApplicationController
  before_filter :authorize_user
  before_filter :authorize_admin, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_course, only: [:show, :quiz, :grade_quiz, :register, :edit, :update, :destroy, :results, :display_certificate, :time_spent_update, :certificate_token, :survey, :survey_response]
  before_action :force_immutability_survey_response, only: [:survey, :survey_response]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # POST /courses/1/time_spent
  def time_spent_update
    @membership.minutes_spent += 1
    @membership.save!
    render :text => "Success"
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /courses/1/register
  def register
    if current_user.balance >= @course.cost
      UserMembership.where(user_id: current_user.id, course_id: @course.id).first_or_create(user_id: current_user.id, course_id: @course.id)
      current_user.balance -= @course.cost
      current_user.save
      flash[:notice] = "You have been successfully registered!"
      redirect_to course_path(@course)
    else
      flash[:error] = "You do not have sufficient funds for this course."
      redirect_to course_path(@course)
    end
  end

  # POST /courses/1/quiz
  def grade_quiz
    correctAnswers = JSON.parse(@course.question_json)["answers"]
    totalCorrect = 0

    (0..correctAnswers.count - 1).each do |n|
      userAnswer = params["question-" + n.to_s].to_i

      if userAnswer === (correctAnswers[n] + 1)
        totalCorrect += 1
      end
    end

    questionCount = (correctAnswers.count > 0) ? correctAnswers.count : 1

    score = ((totalCorrect.to_f / questionCount) * 100)

    if current_user.isEligibleToTakePretest?(@course)
      @membership.pretest_grade = score
      @membership.save!

      if totalCorrect == 0
        flash[:notice] = "You answered no questions correctly"
      elsif totalCorrect == 1
        flash[:notice] = "You answered a question correctly"
      else
        flash[:notice] = "You answered " + totalCorrect.to_s + " questions correctly"
      end

      redirect_to course_path(@course)
    elsif current_user.isEligibleToTakeTest?(@course)
      @membership.setQuizResult(score)
      redirect_to quiz_results_course_path
    end
  end

  # GET /courses/1/quiz/results
  def results
  end

  # GET /courses/1/survey
  def survey
  end

  # POST /courses/1/survey
  def survey_response
    response = params["user_membership"]["special_question_response"]

    if not response.present?
      flash[:error] = "A response is required for the special question."
      redirect_to survey_course_path
      return
    end

    p response
    @membership.special_question_response = response
    p @membership
    @membership.save!

    if @membership.didUserPassCourse?
      redirect_to certificate_course_path(:format => :pdf)
    else
      redirect_to courses_path
    end
  end

  def display_certificate
    if not @membership.didUserPassCourse?
      redirect_to courses_path
      return
    end

    if not @membership.special_question_response.present?
      flash[:error] = "A response is required for the special question."
      redirect_to survey_course_path
      return
    end

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'certificate',
          orientation: 'Landscape',
          background: true,
          template: 'courses/display_certificate.html.erb'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
      @membership = current_user.getMembershipFor(@course)
    end

    def force_immutability_survey_response
      if @membership.special_question_response.present?
        flash[:error] = "You have already responded to the special survey question for this course. Your response cannot be changed."
        redirect_to courses_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :description, :video_url, :minimum_score, :certificate_token, :question_json, :cost, :minimum_time_spent, :special_question, :special_question_response, youtube_video_ids_attributes: [:id, :video_id, :_destroy], course_general_attachments_attributes: [:id, :document, :description, :_destroy], video_uploads_attributes: [:id, :hosted_url, :_destroy])
    end
end
