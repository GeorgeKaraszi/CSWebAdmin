class Api::LdapGroupsController < ApplicationController
  before_action :set_ldap_group, only: [:show, :update, :destroy]

# GET /ldap_groups.json
  def index
    render json: LdapGroup.json_model(LdapGroup.all)
  end

# GET /ldap_groups/1.json
  def show
    render json: LdapGroup.json_model(set_ldap_group)
  end

# POST /ldap_groups.json
  def create
    @ldap_group = LdapGroup.new_entry(ldap_group_params)

    if @ldap_group.save(ldap_group_params)
      render json: true
    else
      render json:@ldap_group.errors, nothing: false
    end

  end

# PATCH/PUT /ldap_groups/1.json
  def update
    if @ldap_group.save(ldap_group_params)
      render json: {notice: 'Ldap group was successfully updated.'}, status: :ok
    else
      render json: @ldap_group.errors, status: :unprocessable_entity
    end
  end

# DELETE /ldap_groups/1.json
  def destroy
    @ldap_group.destroy
    render json: true
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