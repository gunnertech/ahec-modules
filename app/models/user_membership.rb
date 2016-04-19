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
end
