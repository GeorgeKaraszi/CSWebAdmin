class UsersController < ApplicationController
  def index
    @users = User.all_users
  end
  def new
  end

  def show
    unless params.include?(:id)
      flash[:danger] = 'No id was provided'
      redirect_to root_path
    end

    @users = Ldap.find_by_dn(params[:id])

    if @users.blank?
      flash[:danger] = 'Could not find user'
      redirect_to root_path
    else
      @users = @users.first
    end

    @groups = User.find_groups(params[:id])

    end

  def edit
  end

  def create

  end

  def destroy

  end

end
