# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


group_id = AttributeType.create!(:name => 'Groups', :ou_type => 'Groups').id
user_id = AttributeType.create!(:name => 'People', :ou_type => 'People').id

queryInsert = [
    {
        :attribute_type_id => group_id,
        :keyattribute => 'ObjectClass',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => group_id,
        :keyattribute => 'gidNumber',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => group_id,
        :keyattribute => 'memberUid',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => group_id,
        :keyattribute => 'uniqueMember',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => group_id,
        :keyattribute => 'cn',
        :field_type => 'text_box'
    },

    {
        :attribute_type_id => user_id,
        :keyattribute => 'ObjectClass',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'gidNumber',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'uidNumber',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'uid',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'cn',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'givenName',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'loginShell',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'userPassword',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'gecos',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'homeDirectory',
        :field_type => 'text_box'
    },
    {
        :attribute_type_id => user_id,
        :keyattribute => 'firstName',
        :field_type => 'text_box'
    }
]

queryInsert.each do |att|
  AttributeField.create!(att)
end