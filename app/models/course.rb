class Course < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :question_json
  validate :json_format
  validate :valid_youtube_video

  has_many :youtube_video_ids
  has_many :user_memberships
  has_many :users, :through => :user_memberships

  accepts_nested_attributes_for :youtube_video_ids,
    :allow_destroy => true,
    :reject_if     => :all_blank

  protected
  def json_format
    if not JSON.is_json?(question_json)
      errors.add(:question_json, "Must be valid JSON")
    end
  end

  def valid_youtube_video
=begin
    # Let's save this for when we need it
    url = URI.parse(video_url)

    if not url.host == 'www.youtube.com'
      errors.add(:video_url, "Must be a YouTube Video!")
    end

    url = URI.parse('https://www.youtube.com/oembed?url=' + video_url)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true
    res = req.request_head(url.path)

    if not res.code == '200'
      errors.add(:video_url, "Must be a valid YouTube Video!")
    end

    puts url.query
=end
  end
end
