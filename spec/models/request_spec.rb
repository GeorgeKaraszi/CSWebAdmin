require 'rails_helper'

RSpec.describe Request, type: :model do

  describe "must_have" do
    let(:user) {LdapUser.new!({:new => {:uid => 'rspecTester'}})}

    context 'User entry' do
      subject {Request.must_have(user)}

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

  describe 'may_have' do
    let(:user) {LdapUser.new!({:new => {:uid => 'rspecTester'}})}

    context 'User entry' do
      subject {Request.may_have(user)}

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

end
