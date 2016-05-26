class Api::LdapUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ldap_user, only: [:show, :update, :destroy]


  # GET /ldap_users.json
  def index
    render json: LdapUser.all!(LdapUser.all), status: :ok
  end

  # GET /ldap_users/1.json
  def show
    render json: LdapUser.json_model(set_ldap_user), status: :ok
  end

  # POST /ldap_users.json
  def create
    @ldap_user = LdapUser.new_entry(ldap_user_params)

    if @ldap_user.save(ldap_user_params)
      render json: {notice: 'Ldap user was successfully created.', id:@ldap_user.dn.to_s}, status: :ok
    else
      render json: {notice: @ldap_user.errors.messages}, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /ldap_users/1.json
  def update
    if @ldap_user.save(ldap_user_params)
      render json: {notice: 'Ldap user was successfully updated.'}, status: :ok
    else
      render json: {notice: @ldap_user.error_message}, status: :unprocessable_entity
    end
  end

  # DELETE /ldap_users/1.json
  def destroy
    if @ldap_user.destroy
      render json: {notice: 'Ldap user was successfully deleted.'}, status: :ok
    else
      render json: {notice: @ldap_user.errors.messages}, status: :bad_request
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ldap_user
    @ldap_user = LdapUser.find(params[:id])
  rescue ActiveLdap::EntryNotFound
    render json: {notice: 'Entry was not found'}, status: :not_found
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ldap_user_params
    params.require('ldapData')
  end
end
