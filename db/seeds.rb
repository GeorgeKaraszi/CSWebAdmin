# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


AttributeType.delete_all
AttributeName.delete_all

query_insert_names = [
    {
        :keyattribute => 'ObjectClass',
        :description => 'Object Class'
    },
    {
        :keyattribute => 'givenName',
        :description => 'First Name'
    },
    {
        :keyattribute => 'sn',
        :description => 'Last Name'
    },
    {
        :keyattribute => 'displayName',
        :description => 'Display Name'
    },
    {
        :keyattribute => 'uid',
        :description => 'Username'
    },
    {
        :keyattribute => 'gidNumber',
        :description => 'Group ID(GID)'
    },
    {
        :keyattribute => 'uidNumber',
        :description => 'User ID(UID)'
    },
    {
        :keyattribute => 'loginShell',
        :description => 'System Shell Path'
    },
    {
        :keyattribute => 'homeDirectory',
        :description => 'Home Dir. Path'
    },
    {
        :keyattribute => 'userPassword',
        :description => 'Password'
    },
    {
        :keyattribute => 'ou',
        :description => 'Organization Unit'
    },
    {
        :keyattribute => 'memberUid',
        :description => 'Member uid'
    },
    {
        :keyattribute => 'uniqueMember',
        :description => 'Unique Member (Full DN)'
    },
    {
        :keyattribute => 'cn',
        :description => 'Common Name(Global unique name)'
    },
    {
        :keyattribute => 'gecos',
        :description => 'UNIX Account UID'
    },
]

AttributeName.create!(query_insert_names)

queryInsert_group = [
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('ObjectClass').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gidNumber').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('memberUid').id,
        :field_type => 'text_box'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uniqueMember').id,
        :field_type => 'text_box'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('cn').id,
        :field_type => 'text_box'
    }
]

queryInsert_user= [
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('ObjectClass').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gidNumber').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uidNumber').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uid').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('cn').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('givenName').id,
        :field_type => 'text_box'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('loginShell').id,
        :field_type => 'text_box'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('userPassword').id,
        :field_type => 'text_box',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gecos').id,
        :field_type => 'text_box'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('homeDirectory').id,
        :field_type => 'text_box'
    }
]
AttributeType.create!(:name => 'Groups', :ou_type => 'Groups', :fields_attributes => queryInsert_group)
AttributeType.create!(:name => 'People', :ou_type => 'People', :fields_attributes => queryInsert_user)

# queryInsert.each do |att|
#   AttributeField.create!(att)
# end