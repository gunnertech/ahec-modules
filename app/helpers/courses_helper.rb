module CoursesHelper
    def setup_course(course)
      3.times { course.youtube_video_ids.build }

      course
    end
end
