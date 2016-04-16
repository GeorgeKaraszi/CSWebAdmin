class GroupsController < ApplicationController
  def index
    @groups = Group.all_groups
  end

  def create

  end

  def new
  end

  def show
    unless params.include?(:id)
      flash[:danger] = 'No id was provided'
      redirect_to root_path
    end

    @groups = Ldap.find_by_dn(params[:id])

    if @groups.blank?
      flash[:danger] = 'Could not find group'
      redirect_to root_path
    else
      @groups = @groups.first
    end
  end

  def edit
  end


  def destroy

  end
end
