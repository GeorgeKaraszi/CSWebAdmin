class Api::LdapUsersController < ApplicationController
  before_action :set_ldap_user, only: [:show, :update, :destroy]


  # GET /ldap_users.json
  def index
    render json: LdapUser.json_model(LdapUser.all)
  end

  # GET /ldap_users/1.json
  def show
    render json: LdapUser.json_model(set_ldap_user)
  end

  # POST /ldap_users.json
  def create
    @ldap_user = LdapUser.new_entry(ldap_user_params)

    if @ldap_user.save(ldap_user_params)
      render json: true
    else
      render json:@ldap_user.errors, nothing: false
    end

  end

  # PATCH/PUT /ldap_users/1.json
  def update
    if @ldap_user.save(ldap_user_params)
      render nothing: true
    else
      render json: @ldap_user.errors
    end
  end

  # DELETE /ldap_users/1.json
  def destroy
    @ldap_user.destroy
    render json: true
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ldap_user
    @ldap_user = LdapUser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ldap_user_params
    params.require('ldapData')
  end
end
