class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: "user_id", class_name: "User"
  has_many :comments
  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :votes, as: :voteable

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true
  validates :description, presence: true, uniqueness: true

  before_save :generate_slug!

  def total_votes
    upvotes - downvotes
  end

  def upvotes
    votes.where(vote: true).size
  end

  def downvotes
    votes.where(vote: false).size
  end

  def to_param
    slug
  end

  private

  def generate_slug!
    new_slug = to_slug(title)
    post = Post.find_by(slug: new_slug)
    count = 2
    while duplicate_post?(post)
      new_slug = add_numerical_suffix(new_slug, count)
      post = Post.find_by(slug: new_slug)
      count += 1
    end
    self.slug = new_slug
  end

  def duplicate_post?(post)
    post && post != self
  end

  def add_numerical_suffix(slug, count)
    "#{slug.split('_')[0]}_#{count}"
  end

  def to_slug(string)
    slug_string = string.strip
    # Replace non-alphanumeric characters with dashes
    slug_string.gsub!(/\s*[^A-Za-z0-9]\s*/, "-")
    slug_string.gsub!(/-+/, "-")
    slug_string.downcase
  end
end
