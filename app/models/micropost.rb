class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.input.content.max_length}
  validates :image,
    content_type: {in: %w[image/jpeg image/gif image/png],
      message: "must be a valid image format"},
    size: {less_than: (Settings.post.img_limit).megabytes,
      message: "should be less than 5MB"}
  scope :by_created_at, ->{order(created_at: :desc)}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
