class Api::RequestsController < ApplicationController
  before_action :set_user, only: [:ldap_user]
  before_action :set_group, only: [:ldap_group]


  def index
    render json: nil
  end

  def ldap_user
    if @ldap_user
      render json: Request.attribute_query(@ldap_user, 'People')
    else
      render nothing: false
    end
  end

  def ldap_group
    if @ldap_group
      render json: Request.attribute_query(@ldap_group, 'Groups')
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

end
