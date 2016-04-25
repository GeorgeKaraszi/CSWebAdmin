class AttributeType < ActiveRecord::Base

  has_many :fields, class_name: 'AttributeField'
  accepts_nested_attributes_for :fields

  validates_presence_of :name, :ou_type
end
