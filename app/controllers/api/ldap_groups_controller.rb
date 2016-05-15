class Api::LdapGroupsController < ApplicationController
  before_action :set_ldap_group, only: [:show, :edit, :update, :destroy]


  # GET /ldap_groups.json
  def index
    render json: LdapGroup.json_model(LdapGroup.all)
  end


  # GET /ldap_groups/1.json
  def show
    render json: LdapGroup.json_model(set_ldap_group)
  end

  # GET /ldap_groups/new
  def new
    @ldap_group = LdapGroup.new
  end

  # GET /ldap_groups/1/edit
  def edit
  end

  # POST /ldap_groups
  # POST /ldap_groups.json
  def create
    @ldap_user = LdapGroup.new_entry(ldap_group_params)

    if @ldap_user.save(ldap_group_params)
      render json: true
    else
      render json:@ldap_user.errors, nothing: false
    end
  end

  # PATCH/PUT /ldap_groups/1.json
  def update
    if @ldap_group.save(ldap_group_params)
      render nothing: true
    else
      render json: @ldap_group.errors
    end
  end

  # DELETE /ldap_groups/1
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
