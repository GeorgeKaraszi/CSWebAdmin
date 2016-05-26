class Api::LdapGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ldap_group, only: [:show, :update, :destroy]

# GET /ldap_groups.json
  def index
    render json: LdapGroup.all!(LdapGroup.all), status: :ok
  end

# GET /ldap_groups/1.json
  def show
    render json: LdapGroup.json_model(set_ldap_group)
  end

# POST /ldap_groups.json
  def create
    @ldap_group = LdapGroup.new_entry(ldap_group_params)

    if @ldap_group.save(ldap_group_params)
      render json: {notice: 'Ldap group was successfully created.'}, status: :ok
    else
      render json: {notice: @ldap_user.errors}, status: :unprocessable_entity
    end

  end

# PATCH/PUT /ldap_groups/1.json
  def update
    if @ldap_group.save(ldap_group_params)
      render json: {notice: 'Ldap group was successfully updated.'}, status: :ok
    else
      render json: {notice: @ldap_user.errors}, status: :unprocessable_entity
    end
  end

# DELETE /ldap_groups/1.json
  def destroy
    if @ldap_group.destroy
      render json: {notice: 'Ldap group was successfully deleted.'}, status: :ok
    else
      render json: {notice: @ldap_group.errors}, status: :bad_request
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_ldap_group
    @ldap_group = LdapGroup.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def ldap_group_params
    params.require('ldapData')
  end
end
