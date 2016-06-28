require 'rails_helper'

RSpec.describe Request, type: :model do

  describe ".must_have" do
    let(:user) {FactoryGirl.create(:ldap_user)}

    context 'User entry' do
      subject {Request.must_have(user, user.must)}

      it 'returns hash array containing required elements' do
        expected = [
            {key: "sn", title: "Last Name", required:true,  type: "text",
             description: "Last Name"},
            {key:'cn', title: 'Common Name', required:true, type: 'text',
             description:'This refers to the individual object'},
            {key:'uidNumber', title:'User ID', required:true, type: 'number',
             description:'This will identify what user you are on a UNIX system'},
            {key:'gidNumber', title:'Group ID', required:true, type: 'number',
             description: 'Default Group association. This will identify what group you belong to on a UNIX system'}
        ]

        expect(expected & subject).to eq(expected)
      end


    end
  end

  describe '.may_have' do
    let(:user) {FactoryGirl.create(:ldap_user)}

    context 'User entry' do
      subject {Request.may_have(user, user.may)}

      it 'returns a list of optional elements' do
        expected = [
            {key:'loginShell', title: 'Shell Path', type: 'text',
             description:'Path the system will use to locate a bash shell for the user to use'},
            {key:'gecos', title: 'Gecos', type: 'text',
             description:'Contains general information like: location, telephone, and other identifying information.' +
                 ' This is found in most UNIX /etc/passwd files.'},
            {key:'street', title: 'Street Address', type: 'text',
             description: 'Street address of the given entry.'}
        ]

        expect(expected & subject).to eq(expected)
      end
    end

  end

  describe '.attribute_query' do
    let(:user) {FactoryGirl.create(:ldap_user)}

    context 'User entry' do
      subject {Request.attribute_query(user)}

      it 'returns a list of attributes' do
        expected = [
            {title: 'Object Class', key: 'objectClass', type: 'text', val: 'inetOrgPerson,posixAccount', required: true,
             description:'Hierarchical LDAP Schema. This will determine what attributes are available to use.',},
            {title: 'Username', key:'uid', type: 'text', val: user['uid'], required: true,
             description:'Username that will be used to login with on UNIX type systems'},
            {title: 'Street Address', key: 'street', type: 'text',
             description: 'Street address of the given entry.'}
        ]

        expect(expected & subject).to eq(expected)

      end

    end

  end

  describe '.object_query' do
    let(:user) {FactoryGirl.create(:ldap_user)}

    context 'User entry' do
      subject (:alias_request) {Request.object_query(user, 'alias')}
      subject (:bad_request) {Request.object_query(user, 'BadObjectClass')}

      it 'returns a list of attributes that must be met' do
        expected = {key: 'aliasedObjectName', title: 'aliasedEntryName', required:true,  type: 'text',
             description:'RFC4512: name of aliased object'}

        expect(alias_request).to include(expected)
      end

      it 'returns nil if no object class exists' do
        expect(bad_request).to be(nil)
      end
    end

  end

  describe '.object_list_query' do
    let(:user) {FactoryGirl.create(:ldap_user)}
    let(:objectClasses) {['inetOrgPerson', 'posixAccount', 'alias']}

    context 'User entry' do
      subject {Request.object_list_query(user, objectClasses)}
      it 'returns all attributes for current and added attributes' do
        expected = [
            {key: 'aliasedObjectName', title: 'aliasedEntryName', required:true,  type: 'text',
             description:'RFC4512: name of aliased object'},
            {key: "sn", title: "Last Name", required:true,  type: "text",
             description: "Last Name"},
            {key:'cn', title: 'Common Name', required:true, type: 'text',
             description:'This refers to the individual object'}
        ]

        expect(expected & subject).to eq(expected)
      end
    end
  end

  describe '.object_attribute_map' do
    let(:user) {FactoryGirl.create(:ldap_user)}
    let(:objectClasses) {['inetOrgPerson', 'posixAccount', 'alias']}

    context 'User entry' do
      subject {Request.object_attribute_map(user, objectClasses)}
      it 'returns all attributes for current and added attributes' do
        expected = [
            {title: 'Object Class', key: 'objectClass', type: 'text', val: objectClasses.join(','), required: true,
             description:'Hierarchical LDAP Schema. This will determine what attributes are available to use.'},
            {key: 'aliasedObjectName', title: 'aliasedEntryName', required:true,  type: 'text',
             description:'RFC4512: name of aliased object'},
            {key: "sn", title: "Last Name", required:true,  type: 'text', val:'Bad Old Boy',
             description: "Last Name"},
            {key:'cn', title: 'Common Name', required:true, type: 'text', val:'rspecTester',
             description:'This refers to the individual object'}
        ]

        expect(expected & subject).to eq(expected)
      end
    end
  end


  describe '.object_class_list' do
    let(:user) {FactoryGirl.create(:ldap_user)}
    let(:new_class) {['alias']}
    let(:current_class) {['inetOrgPerson', 'posixAccount']}
    subject (:object_list) {Request.object_class_list(user)}

    it 'should return an array' do
      expect(object_list.is_a?(Array)).to be(true)
    end

    it 'should contain all classes not active' do
      expect(new_class & object_list).to eq(new_class)
    end

    it 'should not contain any class that the user has set' do
      expect(current_class & object_list).to be_empty
    end

    it 'should contain more classes then basic' do
      expect(object_list.length).to be > new_class.length
    end


  end

end
