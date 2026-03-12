class Page < ApplicationRecord
  belongs_to :lesson
  has_many :page_views, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :page_translations, dependent: :destroy
  accepts_nested_attributes_for :page_translations, allow_destroy: true, reject_if: :all_blank

  has_rich_text :content
  before_validation :set_default_position
  validates :title, presence: true
  validates :content, presence: true, if: -> { page_translations.empty? }

  def unique_visits
    page_views.distinct.count(:session_hash)
  end
  def translated_title(locale = I18n.locale)
    page_translations.find_by(locale: locale.to_s)&.title || title
  end

  def translated_content(locale = I18n.locale)
    page_translations.find_by(locale: locale.to_s)&.content || content
  end

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  def next_page
    lesson.pages.where("position > ?", position).first
  end

  def previous_page
    lesson.pages.where("position < ?", position).last
  end
  def set_default_position
    return if position.present?
    return if lesson.nil?

    max_position = [
      lesson.pages.maximum(:position) || 0,
      lesson.games.maximum(:position) || 0
    ].max
    self.position = max_position + 1
  end
end
