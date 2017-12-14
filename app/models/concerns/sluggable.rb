module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  module ClassMethods
    def sluggable_column(column_name)
      self.slug_column = column_name
    end
  end

  def to_param
    slug
  end

  private

  def generate_slug!
    new_slug = to_slug(self.send(self.class.slug_column.to_sym))
    model = self.class.find_by(slug: new_slug)
    count = 2
    while duplicate_slug?(model)
      new_slug = add_numerical_suffix(new_slug, count)
      model = self.class.find_by(slug: new_slug)
      count += 1
    end
    self.slug = new_slug
  end

  def duplicate_slug?(model)
    model && model != self
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
