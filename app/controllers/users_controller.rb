class UsersController < ApplicationController
  def index
    @users = User.all_users
  end
  def new
  end

  def show
  end

  def edit
  end

  def create

  end
end
