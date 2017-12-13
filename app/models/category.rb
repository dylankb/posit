class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :posts, through: :categorizations

  before_save :generate_slug!

  validates :name, presence: true

  def to_param
    slug
  end

  private

  def generate_slug!
    new_slug = to_slug(name)
    category = Category.find_by(slug: new_slug)
    count = 2
    while duplicate_category?(category)
      new_slug = add_numerical_suffix(new_slug, count)
      category = Category.find_by(slug: new_slug)
      count += 1
    end
    self.slug = new_slug
  end

  def duplicate_category?(category)
    category && category != self
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
