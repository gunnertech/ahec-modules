class UserMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  validates :user_id, presence: true
  validates :course_id, presence: true

  def setQuizResult(score)
    self.course_grade = score
    self.course_attempts += 1

    self.save
  end

  def hasUserBeenAcceptedIntoCourse?
    return true
    #return self.admin_approved
  end

  def canUserRetakeCourse?
    return (self.course_attempts < 3)
  end

  def didUserPassCourse?
    puts self.course_grade
    puts self.course_id
    puts self.user_id
    puts self.id
    return self.course_grade >= self.course.minimum_score
  end

  def get_completion_time
    start_time = self.created_at
    end_time = self.updated_at

    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    return "#{hours.to_s.rjust(2, '0')} Hrs, #{minutes.to_s.rjust(2, '0')} Mins, #{seconds.to_s.rjust(2, '0')} Secs"
  end
end
