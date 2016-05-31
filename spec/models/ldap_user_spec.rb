require 'rails_helper'

RSpec.describe LdapUser, type: :model do

  describe ".all" do
    entry_list = LdapUser.all

    it 'returns an array of all entry users' do
      expect(entry_list.is_a?(Array)).to eq(true)
    end
    it 'all entries contain a dn attribute' do
      expect(entry_list.all? { |e| e.dn }).to_not be(nil)
    end
    it 'all entries contains a list of attributes' do
      expect(entry_list.all? { |e| e.attributes }).to_not be(nil)
    end
    it "all user entries contains an identifier of 'uid'" do
      expect(entry_list.all? { |e| e.attributes.has_key?('uid') }).to be(true)
    end
  end

  describe 'self.json_model' do
    context 'single entry' do
      hash_entry = LdapUser.json_model(LdapUser.first)

      it 'returns a single hash model of the entry' do
        expect(hash_entry.is_a?(Hash)).to eq(true)
      end
      it 'contains a dn attribute' do
        expect(hash_entry.has_key?(:dn)).to be(true)
      end
      it 'contains a cn attribute' do

        expect(hash_entry.has_key?(:cn)).to be(true)
      end
      it 'contains a list of hashed attributes' do
        expect(hash_entry.has_key?(:attributes)).to be(true)
      end
    end

    context 'multiple entries' do
      hash_entry = LdapUser.json_model(LdapUser.all)

      it 'returns an array of hashed entries' do
        expect(hash_entry.is_a?(Array)).to eq(true)
        expect(hash_entry.first.is_a?(Hash)).to eq(true)
      end
      it 'all entries contains a dn attribute' do
        expect(hash_entry.all? { |e| e.has_key?(:dn) }).to be(true)
      end
      it 'all entries contains a cn attribute' do
        expect(hash_entry.all? { |e| e.has_key?(:cn) }).to be(true)
      end
      it 'all entries contains a list of hashed attributes' do
        expect(hash_entry.all? { |e| e.has_key?(:attributes) }).to be(true)
      end
    end
  end

  describe 'create new entry' do
    let(:user_att) {FactoryGirl.attributes_for(:ldap_user)}

    context 'no attributes provided' do
      user = LdapUser.new

      it 'expects user to raise error' do
        expect{user.save!}.to raise_error(ActiveLdap::EntryInvalid)
      end
      it "contains an error that 'dn'(uid) was not provided" do
        expect(user.errors.messages.any? { |e| e[0] == :distinguishedName }).to be(true)
      end

      context 'objectClass: posixAccount' do

        it "should contain an error that 'uid' was not provided" do
          expect(user.errors.messages.any? { |e| e[0] == :uid }).to be(true)
        end

        it "should contain an error that 'homeDirectory' was not provided" do
          expect(user.errors.messages.any? { |e| e[0] == :homeDirectory }).to be(true)
        end

        it "should contain an error that 'uidNumber' was not provided" do
          expect(user.errors.messages.any? { |e| e[0] == :uidNumber }).to be(true)
        end
      end

      context 'objectClass: inetOrgPerson' do
        it "contains an error that 'sn' was not provided" do
          expect(user.errors.messages.any? { |e| e[0] == :sn }).to be(true)
        end
      end
    end

    context 'attributes are provided' do

      it "returns successful save" do
        user = LdapUser.new_entry(user_att)
        expect(user.save(user_att)).to eq(true)
      end
    end
  end

  describe 'Editing user' do
    let(:user)  {FactoryGirl.create(:ldap_user)}
    let (:good)  {{:loginShell =>  "/bin/sh"}}
    let (:bad)  {{badAttribute: 'nada'}}

    context 'valid attributes being added' do
      it "does not contain 'loginShell' attribute" do
        expect(user.attributes['loginShell']).to be(nil)
      end

      it "successfully added 'loginShell' attribute" do
        expect(user.save(good)).to be(true)
        expect(user['loginShell']).to eq(good[:loginShell])
      end
    end

    context 'invalid attribute being added' do
      it "throws an error for adding invalid attributes" do
        expect(user.save(bad)).to be(false)
      end
    end
  end

  describe '.objects_to_remove' do
    let(:user) {FactoryGirl.create(:ldap_user)}
    subject(:input_params) {['posixAccount']}
    subject(:empty_params) {['inetOrgPerson','posixAccount']}

    it 'returns an array of objects that should be removed from the entry' do
      expected = ['inetOrgPerson']
      expect(user.objects_to_remove(input_params)).to eq(expected)
    end

    it 'returns an empty array' do
      expect(user.objects_to_remove(empty_params)).to be_empty
    end

  end

  describe '.objects_to_add' do
    let(:user) {FactoryGirl.create(:ldap_user)}
    subject(:input_params) {['inetOrgPerson','shadowAccount','posixAccount']}
    subject(:empty_params) {['inetOrgPerson','posixAccount']}

    it 'returns an array of objects that should be added to the entry' do
      expected = ['shadowAccount']
      expect(user.objects_to_add(input_params)).to eq(expected)
    end

    it 'returns an empty array' do
      expect(user.objects_to_add(empty_params)).to be_empty
    end

  end


  describe '.object_must_lookup' do
    let (:user) {FactoryGirl.create(:ldap_user)}
    subject(:object_query) {user.object_class_must_lookup('shadowAccount')}

    it 'successfully finds the object class' do
      expect(object_query).to_not be(nil)
    end

    it 'returns an array of attributes that must be met' do
      expect(object_query.is_a?(Array)).to be(true)
    end

    it 'contains key names for each attribute' do
      object_query.each {|a| expect(a.name).to_not be(nil)}
    end

    it 'returns nil if object does not exists' do
      expect(user.object_class_must_lookup('BadObjectClass')).to be(nil)
    end

  end
end
