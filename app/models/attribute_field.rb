class AttributeField < ActiveRecord::Base
  belongs_to :attribute_type
  belongs_to :attribute_name

  validates_presence_of :field_type
end
