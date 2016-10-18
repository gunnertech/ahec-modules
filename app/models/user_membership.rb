require 'csv'

class UserMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  validates :user_id, presence: true
  validates :course_id, presence: true

  def setQuizResult(score)
    self.course_grade = score
    self.course_attempts += 1

    if score >= self.course.minimum_score
      self.passed_on = Time.now
    end

    self.save
  end

  def hasUserBeenAcceptedIntoCourse?
    return true
    #return self.admin_approved
  end


  def canUserRetakeCourse?
    return ((self.course_attempts < 3) && (!didUserPassCourse?))
  end

  def didUserPassCourse?
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

  def self.to_csv
    attributes = %w{id course_id user_id created_at updated_at admin_approved course_grade course_attempts pretest_grade minutes_spent }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |membership|
        csv << attributes.map{ |attr| membership.send(attr) }
      end
    end
  end
end
