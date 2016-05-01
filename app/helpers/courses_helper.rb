module CoursesHelper
    def setup_course(course)
      3.times { course.youtube_video_ids.build }
      3.times { course.video_uploads.build }
      3.times { course.course_general_attachments.build }

      course
    end
end
