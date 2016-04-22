class LdapUsersController < ApplicationController
  before_action :set_ldap_user, only: [:show, :edit, :update, :destroy]

  # GET /ldap_users
  # GET /ldap_users.json
  def index
    @ldap_users = LdapUser.all
  end

  # GET /ldap_users/1
  # GET /ldap_users/1.json
  def show
    @ldap_user = set_ldap_user
  end

  # GET /ldap_users/new
  def new
    @ldap_user = LdapUser.new
  end

  # GET /ldap_users/1/edit
  def edit
  end

  # POST /ldap_users
  # POST /ldap_users.json
  def create
    @ldap_user = LdapUser.new(ldap_user_params)

    respond_to do |format|
      if @ldap_user.save
        format.html { redirect_to @ldap_user, notice: 'Ldap user was successfully created.' }
        format.json { render :show, status: :created, location: @ldap_user }
      else
        format.html { render :new }
        format.json { render json: @ldap_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ldap_users/1
  # PATCH/PUT /ldap_users/1.json
  def update
    respond_to do |format|
      if @ldap_user.update(ldap_user_params)
        format.html { redirect_to @ldap_user, notice: 'Ldap user was successfully updated.' }
        format.json { render :show, status: :ok, location: @ldap_user }
      else
        format.html { render :edit }
        format.json { render json: @ldap_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ldap_users/1
  # DELETE /ldap_users/1.json
  def destroy
    @ldap_user.destroy
    respond_to do |format|
      format.html { redirect_to ldap_users_url, notice: 'Ldap user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ldap_user
      @ldap_user = LdapUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ldap_user_params
      params.fetch(:ldap_user, {})
    end
end
