class RequestsController < ApplicationController
  before_action :set_user, only: [:ldap_user, :ldap_test]
  before_action :set_group, only: [:ldap_group]


  def index
    respond_to do |format|
      format.js { render json: nil }
    end
  end

  def ldap_user
    respond_to do |format|
      if @ldap_user
        format.json { render json: Request.attribute_query(@ldap_user, 'People') }
      else
        format.json { render json: nil }
      end
    end
  end

  def ldap_group
    respond_to do |format|
      if @ldap_group
        format.json { render json: Request.attribute_query(@ldap_group, 'Groups') }
      else
        format.json { render json: nil }
      end
    end
  end


  def ldap_test
    respond_to do |format|
      if @ldap_user
        format.json { render json: Request.test_query(@ldap_user, 'People') }
      else
        format.json { render json: nil }
      end
    end
  end

  private

  def set_user
    @ldap_user = LdapUser.find(params[:id]) if params.has_key?('id')
    @ldap_user = LdapUser.new unless @ldap_user
  end

  def set_group
    @ldap_group = LdapGroup.find(params[:id]) if params.has_key?('id')
    @ldap_group = LdapGroup.new unless @ldap_group
  end

  def request_params
    JSON.load(params.require(:request_data))
  end

end
