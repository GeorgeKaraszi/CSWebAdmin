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
        :title => 'Object Class',
        :keyattribute => 'objectClass',
        :description => 'Hierarchical LDAP Schema. This will determine what attributes are available to use.'
    },
    {
        :title => 'First Name',
        :keyattribute => 'givenName',
        :description => 'First Name'
    },
    {
        :title => 'Last Name',
        :keyattribute => 'sn',
        :description => 'Last Name'
    },
    {
        :title => 'Display Name',
        :keyattribute => 'displayName',
        :description => 'Name that will be displayed on a UNIX system'
    },
    {
        :title => 'Username',
        :keyattribute => 'uid',
        :description => 'Username that will be used to login with on UNIX type systems'
    },
    {
        :title => 'Group ID',
        :keyattribute => 'gidNumber',
        :description => 'Default Group association. This will identify what group you belong to on a UNIX system'
    },
    {
        :title => 'User ID',
        :keyattribute => 'uidNumber',
        :description => 'This will identify what user you are on a UNIX system'
    },
    {
        :title => 'Shell Path',
        :keyattribute => 'loginShell',
        :description => 'Path the system will use to locate a bash shell for the user to use'
    },
    {
        :title => 'Home Dir.',
        :keyattribute => 'homeDirectory',
        :description => 'Directory the System will assign to the user upon logging in'
    },
    {
        :title => 'Password',
        :keyattribute => 'userPassword',
        :description => 'Password that the system will use to authenticate with'
    },
    {
        :title => 'Organizational Unit',
        :keyattribute => 'ou',
        :description => 'Classification to where this entry is located on the ldap system... EG OU=People OU=Lawyer'
    },
    {
        :title => 'Member UID',
        :keyattribute => 'memberUid',
        :description => 'Will assign a user to the group based on their username'
    },
    {
        :title => 'Unique Member(DN)',
        :keyattribute => 'uniqueMember',
        :description => 'Will assign a user to the group with a complete identification of their full DN. ' +
            'This is useful for authentication. This is NOT compatible with UNIX groups.'
    },
    {
        :title => 'Common Name',
        :keyattribute => 'cn',
        :description => 'This refers to the individual object'
    },
    {
        :title => 'Gecos',
        :keyattribute => 'gecos',
        :description => 'Contains general information like: location, telephone, and other identifying information. ' +
            'This is found in most UNIX /etc/passwd files.'
    },
    {
        :title => 'Street Address',
        :keyattribute => 'street',
        :description => 'Street address of the given entry.'
    }
]
puts query_insert_names

AttributeName.create!(query_insert_names)

query_insert_group = [
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('ObjectClass').id,
        :field_type => 'text',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gidNumber').id,
        :field_type => 'number',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('memberUid').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uniqueMember').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('cn').id,
        :field_type => 'text',
        :required => true
    }
]

query_insert_user= [
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('ObjectClass').id,
        :field_type => 'text',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gidNumber').id,
        :field_type => 'number',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uidNumber').id,
        :field_type => 'number',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('uid').id,
        :field_type => 'text',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('cn').id,
        :field_type => 'text',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('givenName').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('sn').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('loginShell').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('userPassword').id,
        :field_type => 'password',
        :required => true
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('gecos').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('homeDirectory').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('displayName').id,
        :field_type => 'text'
    },
    {
        :attribute_name_id => AttributeName.find_by_keyattribute('street').id,
        :field_type => 'text'
    }
]

puts query_insert_group
puts query_insert_user

AttributeType.create!(:name => 'Groups', :ou_type => 'Groups', :fields_attributes => query_insert_group)
AttributeType.create!(:name => 'People', :ou_type => 'People', :fields_attributes => query_insert_user)