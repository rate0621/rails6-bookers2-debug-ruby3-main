class Book < ApplicationRecord
  # has_many :user
  belongs_to :user
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


scope :popular_this_week, -> {
  select('books.*, COUNT(favorites.id) AS favorites_count')
  .joins('LEFT JOIN favorites ON favorites.book_id = books.id')
  .where('favorites.created_at >= ? OR favorites.created_at IS NULL', 1.week.ago)
  .group('books.id')
  .order('favorites_count DESC')
}

end
