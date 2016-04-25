class AttributeField < ActiveRecord::Base
  belongs_to :attribute_type

  validates_presence_of :keyattribute, :field_type
end
