class Page < ApplicationRecord
  belongs_to :lesson
  has_many :page_views, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_rich_text :content
  validates :title, :content, :position, presence: true

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  def next_page
    lesson.pages.where("position > ?", position).first
  end

  def previous_page
    lesson.pages.where("position < ?", position).last
  end
end
