json.array!(@courses) do |course|
  json.extract! course, :id, :title, :description, :videoUrl
  json.url course_url(course, format: :json)
end
