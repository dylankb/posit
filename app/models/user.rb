class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: { minimum: 6 }

  before_save :generate_slug

  def to_param
    slug
  end

  private

  def generate_slug!
    new_slug = to_slug(username)
    user = User.find_by(slug: new_slug)
    count = 2
    while duplicate_user?(user)
      new_slug = add_numerical_suffix(new_slug, count)
      user = User.find_by(slug: new_slug)
      count += 1
    end
    self.slug = new_slug
  end

  def duplicate_user?(user)
    user && user != self
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
