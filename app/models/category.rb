class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :posts, through: :categorizations

  validates :name, presence: true
end
