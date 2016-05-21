require 'rails_helper'

RSpec.describe LdapUser, type: :model do

  describe ".all" do
    it 'returns all entry users' do
      entry_list = LdapUser.all
      expect(entry_list.is_a?(Array)).to eq(true)
      expect(entry_list.all? { |e| e.dn }).to_not be(nil)
      expect(entry_list.all? { |e| e.attributes }).to_not be(nil)
      expect(entry_list.all? { |e| e.attributes.has_key?('uid') }).to be(true)
    end
  end

  describe 'self.json_model' do
    context 'single entry' do
      it 'returns a hash model for the given entry' do
        hash_entry = LdapUser.json_model(LdapUser.first)
        expect(hash_entry.is_a?(Array)).to eq(false)
        expect(hash_entry.has_key?(:dn)).to be(true)
        expect(hash_entry.has_key?(:cn)).to be(true)
        expect(hash_entry.has_key?(:attributes)).to be(true)
      end
    end

    context 'multiple entries' do
      it 'returns all models in a hash array' do
        hash_entry = LdapUser.json_model(LdapUser.all)
        expect(hash_entry.is_a?(Array)).to eq(true)
        expect(hash_entry.all? { |e| e.has_key?(:dn) }).to be(true)
        expect(hash_entry.all? { |e| e.has_key?(:cn) }).to be(true)
        expect(hash_entry.all? { |e| e.has_key?(:attributes) }).to be(true)
      end
    end
  end


end
