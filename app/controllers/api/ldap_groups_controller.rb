class Api::LdapGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ldap_group, only: [:show, :update, :destroy]


  # GET /api/ldap_groups.json
  def index
    render json: LdapGroup.all!(LdapGroup.all), status: :ok
  end

  # GET /api/ldap_groups/1.json
  def show
    render json: LdapGroup.json_model(set_ldap_group), status: :ok
  end

  # POST /api/ldap_groups.json
  def create
    @ldap_group = LdapGroup.new_entry(ldap_group_params)

    if @ldap_group.save(ldap_group_params)
      render json: {notice: 'Ldap group was successfully created.', id:@ldap_group.dn.to_s}, status: :ok
    else
      render json: {notice: @ldap_group.errors.messages}, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /api/ldap_groups/1.json
  def update
    if @ldap_group.save(ldap_group_params)
      render json: {notice: 'Ldap group was successfully updated.', id:@ldap_group.dn.to_s}, status: :ok
    else
      render json: {notice: @ldap_group.error_message}, status: :unprocessable_entity
    end
  end

  # DELETE /api/ldap_groups/1.json
  def destroy
    if @ldap_group.destroy
      render json: {notice: 'Ldap group was successfully deleted.'}, status: :ok
    else
      render json: {notice: @ldap_group.errors.messages}, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ldap_group
    @ldap_group = LdapGroup.find(params[:id])
  rescue ActiveLdap::EntryNotFound
    render json: {notice: 'Entry was not found'}, status: :not_found
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ldap_group_params
    params.require('ldapData')
  end
end
