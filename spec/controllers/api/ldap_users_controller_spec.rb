require 'rails_helper'

RSpec.describe Api::LdapUsersController, type: :controller do

  describe "Get 'index'" do

    context 'when user is not login' do
      it 'returns a routing error' do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end


    context 'when the user is login' do
      login_user

      it 'returns a list of all users' do
        get :index, format: :json
        user_list = JSON.parse(response.body)
        expect(user_list.length).to be > (10)
        expect(user_list.all? {|e|e.has_key?('dn')}).to eq(true)
        expect(user_list.all? {|e|e.has_key?('cn')}).to eq(true)
        expect(user_list.all? {|e| e.has_key?('idNum')}).to eq(true)
      end
    end
  end



  describe "POST 'create' " do
    login_user

    context "incorrect Posix objectClass attributes" do
      bad_user = FactoryGirl.attributes_for(:ldap_user)
      bad_user.delete(:homeDirectory)

      it "returns an error if no homeDirectory is present" do
        post :create, :ldapData => bad_user
        parsed_results = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_results['notice'].first).to include('homeDirectory')
      end
    end


    context "correct objectClass attributes" do
      it "returns a successful json string with success message" do
        post :create, :ldapData => FactoryGirl.attributes_for(:ldap_user)
        parsed_results = JSON.parse(response.body)
        expect(response).to be_success
        expect(parsed_results['notice']).to eq('Ldap user was successfully created.')
      end
    end
  end



  describe "Get 'show'" do
    login_user

    let(:user) {FactoryGirl.create(:ldap_user)}
    let(:bad_user) {'uid=doesNotExist'}

    it 'returns a successful 200 response' do
      get :show, :id => user['dn']
      expect(response).to be_success

    end

    it 'returns data of a single user entry' do
      get :show, :id => user['dn']
      parsed_results = JSON.parse(response.body)
      expect(parsed_results['dn']).to_not be_nil
      expect(parsed_results['attributes']).to_not be_nil
      expect(parsed_results['attributes']['uid']).to_not be_nil
    end

    it 'returns an error if user entry does not exist' do
      get :show, :id => bad_user
      parsed_results = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(parsed_results['notice']).to eq('Entry was not found')
    end
  end



  describe "Delete 'destroy'" do
    login_user
    let (:user) {FactoryGirl.create(:ldap_user)}
    let(:bad_user) {'uid=doesNotExist'}

    it 'returns successful 200 response' do
      delete :destroy, :id=> user['dn'], format: :json
      parsed_results = JSON.parse(response.body)
      expect(parsed_results['notice']).to eq('Ldap user was successfully deleted.')
      expect(response).to be_success
    end

    it 'returns error user not found' do
      delete :destroy, :id=> bad_user, format: :json
      parsed_results = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(parsed_results['notice']).to eq('Entry was not found')
    end

  end

end
