class CoursesController < ApplicationController
  before_filter :authorize_user

  before_action :set_course, only: [:show, :quiz, :grade_quiz, :register, :edit, :update, :destroy, :results]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
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
    UserMembership.where(course_id: @course.id).destroy_all
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

      if userAnswer == correctAnswers[n]
        totalCorrect += 1
      end
    end

    puts totalCorrect
    puts correctAnswers

    score = ((totalCorrect / correctAnswers.count) * 100).round
    puts score
    membership = current_user.getMembershipFor(@course)
    membership.setQuizResult(score)

    redirect_to quiz_results_course_path
  end

  # GET /courses/1/quiz/results
  def results
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :description, :video_url, :minimum_score,
                                     :question_json)
    end
end
