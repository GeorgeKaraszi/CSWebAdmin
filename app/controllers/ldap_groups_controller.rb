class LdapGroupsController < ApplicationController
  before_action :set_ldap_group, only: [:show, :edit, :update, :destroy]

  # GET /ldap_groups
  # GET /ldap_groups.json
  def index
    @ldap_groups = LdapGroup.all
  end

  # GET /ldap_groups/1
  # GET /ldap_groups/1.json
  def show
    set_ldap_group
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
    @ldap_group = LdapGroup.new(ldap_group_params)

    respond_to do |format|
      if @ldap_group.save
        format.html { redirect_to @ldap_group, notice: 'Ldap group was successfully created.' }
        format.json { render :show, status: :created, location: @ldap_group }
      else
        format.html { render :new }
        format.json { render json: @ldap_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ldap_groups/1
  # PATCH/PUT /ldap_groups/1.json
  def update
    respond_to do |format|
      if @ldap_group.update(ldap_group_params)
        format.html { redirect_to @ldap_group, notice: 'Ldap group was successfully updated.' }
        format.json { render :show, status: :ok, location: @ldap_group }
      else
        format.html { render :edit }
        format.json { render json: @ldap_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ldap_groups/1
  # DELETE /ldap_groups/1.json
  def destroy
    @ldap_group.destroy
    respond_to do |format|
      format.html { redirect_to ldap_groups_url, notice: 'Ldap group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ldap_group
      @ldap_group = LdapGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ldap_group_params
      params.fetch(:ldap_group, {})
    end
end
