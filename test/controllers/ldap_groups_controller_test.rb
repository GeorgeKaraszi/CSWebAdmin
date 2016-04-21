require 'test_helper'

class LdapGroupsControllerTest < ActionController::TestCase
  setup do
    @ldap_group = ldap_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ldap_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ldap_group" do
    assert_difference('LdapGroup.count') do
      post :create, ldap_group: {  }
    end

    assert_redirected_to ldap_group_path(assigns(:ldap_group))
  end

  test "should show ldap_group" do
    get :show, id: @ldap_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ldap_group
    assert_response :success
  end

  test "should update ldap_group" do
    patch :update, id: @ldap_group, ldap_group: {  }
    assert_redirected_to ldap_group_path(assigns(:ldap_group))
  end

  test "should destroy ldap_group" do
    assert_difference('LdapGroup.count', -1) do
      delete :destroy, id: @ldap_group
    end

    assert_redirected_to ldap_groups_path
  end
end
