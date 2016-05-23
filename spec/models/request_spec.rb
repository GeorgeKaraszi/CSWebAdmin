require 'rails_helper'

RSpec.describe Request, type: :model do

  describe "must_have" do
    let(:user) {LdapUser.new!({:new => {:uid => 'rspecTester'}})}

    context 'User entry' do
      subject {Request.must_have(user)}

      it 'returns hash array containing required elements' do
        expected = [
            {key:'sn', alias: 'Last Name', description:'Last Name'},
            {key:'cn', alias: 'Common Name', description:'This refers to the individual object'},
            {key:'uidNumber', alias:'User ID', description:'This will identify what user you are on a UNIX system'},
            {key:'gidNumber', alias:'Group ID', description: 'Default Group association. This will identify what group you belong to on a UNIX system'}
        ]
        expected.each do |ex|
          expect(subject).to include(ex)
        end

      end


    end
  end

  describe 'may_have' do
    let(:user) {LdapUser.new!({:new => {:uid => 'rspecTester'}})}

    context 'User entry' do
      subject {Request.may_have(user)}

      it 'returns a list of optional elements' do
        expected = [
            {key:'loginShell', alias: 'Shell Path', description:'Path the system will use to locate a bash shell for the user to use'},
            {key:'gecos', alias: 'Gecos', description:'Contains general information like: location, telephone, and other identifying information. This is found in most UNIX /etc/passwd files.'},
            {key:'street', alias: 'Street Address', description: 'Street address of the given entry.'}
        ]

        expected.each do |ex|
          expect(subject).to include(ex)
        end
      end
    end

  end
end
