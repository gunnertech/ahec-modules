class CoursesController < ApplicationController
  before_filter :authorize_user

  before_action :set_course, only: [:show, :quiz, :grade_quiz, :register, :edit, :update, :destroy, :results, :display_certificate, :time_spent_update]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # POST /courses/1/time_spent
  def time_spent_update
    membership = current_user.getMembershipFor(@course)
    membership.minutes_spent += 1
    membership.save!
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
    current_user.registerFor(@course)
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

    score = ((totalCorrect / questionCount) * 100).round
    membership = current_user.getMembershipFor(@course)

    if current_user.isEligibleToTakePretest?(@course)
      membership.pretest_grade = score
      membership.save!

      if totalCorrect == 0
        flash[:notice] = "You answered no questions correctly"
      elsif totalCorrect == 1
        flash[:notice] = "You answered a question correctly"
      else
        flash[:notice] = "You answered " + totalCorrect.to_s + " questions correctly"
      end

      redirect_to course_path(@course)
    elsif current_user.isEligibleToTakeTest?(@course)
      membership.setQuizResult(score)
      redirect_to quiz_results_course_path
    end
  end

  # GET /courses/1/quiz/results
  def results
  end

  def display_certificate
    @membership = current_user.getMembershipFor(@course)

    if not @membership.didUserPassCourse?
      redirect_to courses_path
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :description, :video_url, :minimum_score,
                                     :question_json, :minimum_time_spent, youtube_video_ids_attributes: [:id, :video_id, :_destroy], course_general_attachments_attributes: [:id, :document, :description, :_destroy], video_uploads_attributes: [:id, :hosted_url, :_destroy])
    end
end
