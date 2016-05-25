class WelcomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_counters, only: [:index]
  def index
  end

  private
  def set_counters
    @group_counter = LdapGroup.all.count
    @user_counter = LdapUser.all.count
  end
end
