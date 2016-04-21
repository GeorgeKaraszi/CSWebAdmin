require 'test_helper'

class LdapUsersControllerTest < ActionController::TestCase
  setup do
    @ldap_user = ldap_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ldap_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ldap_user" do
    assert_difference('LdapUser.count') do
      post :create, ldap_user: {  }
    end

    assert_redirected_to ldap_user_path(assigns(:ldap_user))
  end

  test "should show ldap_user" do
    get :show, id: @ldap_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ldap_user
    assert_response :success
  end

  test "should update ldap_user" do
    patch :update, id: @ldap_user, ldap_user: {  }
    assert_redirected_to ldap_user_path(assigns(:ldap_user))
  end

  test "should destroy ldap_user" do
    assert_difference('LdapUser.count', -1) do
      delete :destroy, id: @ldap_user
    end

    assert_redirected_to ldap_users_path
  end
end
