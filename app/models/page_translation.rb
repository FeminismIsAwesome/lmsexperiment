class PageTranslation < ApplicationRecord
  belongs_to :page
  has_rich_text :content

  validates :locale, :title, presence: true
  validates :locale, uniqueness: { scope: :page_id }
end
