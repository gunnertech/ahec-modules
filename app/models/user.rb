class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_memberships
  has_many :courses, :through => :user_memberships

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :dob
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :profession
  validates :email, uniqueness: true

  def getDisplayName
    return (self.first_name + " " + self.last_name)
  end

  def isRegisteredFor?(course)
    return true
    #return self.courses.exists?(course.id)
  end

  def isEligibleToTakeTest?(course)
    membership = self.getMembershipFor(course)

    if not membership
      #return false
      self.registerFor(course)
    end

    if not membership.hasUserBeenAcceptedIntoCourse?
      return false
    end

    if not membership.canUserRetakeCourse?
      return false
    end

    if membership.didUserPassCourse?
      return false
    end

    return true
  end
  
  def registerFor(course)
    UserMembership.where(:course => course).first_or_create(user_id: self.id, course_id: course.id)
  end

  def getMembershipFor(course)
    return UserMembership.where(course_id: course.id).first
  end
end
