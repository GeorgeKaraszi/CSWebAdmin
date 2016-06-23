class Api::RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:ldap_user, :ldap_user_object]
  before_action :set_group, only: [:ldap_group, :ldap_group_object]


  def index
    render json: nil
  end

  def ldap_user
    if @ldap_user
      render json: Request.attribute_query(@ldap_user)
    else
      render nothing: false
    end
  end

  def ldap_group
    if @ldap_group
      render json: Request.attribute_query(@ldap_group)
    else
      render nothing: false
    end
  end

  def ldap_user_object
    if @ldap_user
      render json: Request.object_attribute_map(@ldap_user, object_params)
    else
      render nothing: false
    end
  end

  def ldap_group_object
    if @ldap_group
      render json: Request.object_attribute_map(@ldap_group, object_params)
    else
      render nothing: false
    end
  end


  private

  def set_user
    @ldap_user = LdapUser.find(params[:id]) if params.has_key?('id')
    @ldap_user ||= LdapUser.new
  end

  def set_group
    @ldap_group = LdapGroup.find(params[:id]) if params.has_key?('id')
    @ldap_group ||= LdapGroup.new
  end

  def object_params
    params.require(:obj).split(',')
  end

end
