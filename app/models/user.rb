class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_memberships, dependent: :destroy
  has_many :courses, :through => :user_memberships

  validates :email, uniqueness: true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :dob
  validates_presence_of :social_security
  validates_presence_of :personal_phone
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :employer
  validates_presence_of :employer_phone
  validates_presence_of :employer_city
  validates_presence_of :employer_state
  validates_presence_of :employer_zip
  validates_presence_of :employer_address
  validates_presence_of :profession

  def getDisplayName
    return (self.first_name + " " + self.last_name)
  end

  def isRegisteredFor?(course)
    return self.courses.exists?(course.id)
  end

  def isEligibleToTakePretest?(course)
    membership = self.getMembershipFor(course)

    if membership
      if not membership.pretest_grade
        if membership.course_attempts == 0
          return true
        end
      end
    end

    return false
  end

  def isEligibleToTakeTest?(course)
    membership = self.getMembershipFor(course)

    if not membership
      return false
    end

    if not membership.pretest_grade
      return false
    end

    if not membership.canUserRetakeCourse?
      return false
    end

    if membership.minutes_spent < course.minimum_time_spent
      return false
    end

    return true
  end
  
  def getMembershipFor(course)
    return UserMembership.where(user_id: self.id, course_id: course.id).first
  end

  def get_passed_courses
    @memberships = UserMembership.where(user_id: self.id)
    @memberships = @memberships.map { |membership|
      if membership.didUserPassCourse?
        membership
      end
    }.compact.uniq { |m| m.id }

    @courses = @memberships.map { |m| m.course }.compact.uniq { |c| c.id }

    return @courses
  end
end
