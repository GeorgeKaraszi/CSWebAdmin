class Api::RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:ldap_user]
  before_action :set_group, only: [:ldap_group]
  before_action :set_entry, only: [:ldap_attributes, :ldap_schema_list, :ldap_schema_attributes]


  #
  #
  # DEFAULT RETURN
  ############################################################################
  def index
    render json: nil
  end

  #
  # Get api/v1/user/new
  # Get api/user/:id
  ############################################################################
  def ldap_user
    if @ldap_user
      render json: Request.attribute_query(@ldap_user)
    else
      render nothing: false
    end
  end

  #
  # Get api/v1/group/new
  # Get api/v1/group/:id
  ############################################################################
  def ldap_group
    if @ldap_group
      render json: Request.attribute_query(@ldap_group)
    else
      render nothing: false
    end
  end

  #
  #
  # GET api/v1/request/:id
  ############################################################################
  def ldap_attributes
    if @ldap_entry
      render json: Request.attribute_query(@ldap_entry)
    else
      render nothing: false
    end
  end

  #
  #
  # GET api/v1/request/:id/schema
  # GET api/v1/request/schema
  ############################################################################
  def ldap_schema_list
    if @ldap_entry
      render json: Request.object_class_list(@ldap_entry)
    else
      render nothing: false
    end
  end

  #
  #
  # GET api/v1/request/:id/schema/:schema
  # GET api/v1/request/schema/:schema
  ############################################################################
  def ldap_schema_attributes
    if @ldap_entry
      render json: Request.object_attribute_map(@ldap_entry, schema_params)
    else
      render nothing: false
    end
  end


  private

  def set_entry
    @ldap_entry = LdapBase.find(params[:id]) if params.has_key?('id')
    @ldap_entry ||= LdapBase.send(:new)

  rescue ActiveLdap::EntryNotFound
    @ldap_entry = nil

  end

  def set_user
    @ldap_user = LdapUser.find(params[:id]) if params.has_key?('id')

  rescue ActiveLdap::EntryNotFound
      @ldap_user = LdapUser.send(:new)
  end

  def set_group
    @ldap_group = LdapGroup.find(params[:id]) if params.has_key?('id')

  rescue ActiveLdap::EntryNotFound
      @ldap_group = LdapGroup.send(:new)
  end

  def schema_params
    params.require(:schema).split(',')
  end

end
