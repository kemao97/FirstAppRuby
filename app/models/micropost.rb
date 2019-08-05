class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_time_desc, -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.models.micropost.content.max_length }
  validate  :picture_size

  def picture_size
    return if picture.size <= Settings.models.micropost.max_upload.megabytes
    errors.add :picture, I18n.t(".picture_limit")
  end
end
