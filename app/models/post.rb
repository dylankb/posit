class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: "user_id", class_name: "User"
  has_many :comments
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :votes, as: :voteable

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true
  validates :description, presence: true, uniqueness: true

  def total_votes
    upvotes - downvotes
  end

  def upvotes
    votes.where(vote: true).size
  end

  def downvotes
    votes.where(vote: false).size
  end
end
