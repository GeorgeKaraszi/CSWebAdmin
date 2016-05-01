class AttributeName < ActiveRecord::Base
  has_many :attribute_fields

  validates_uniqueness_of :keyattribute
  validates_presence_of :keyattribute, :description, :title

end
