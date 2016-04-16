require 'ldap/admin'

class User < ActiveRecord::Base
  #require "ldap/admin"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_auth, :rememberable, :trackable


  def self.all_users
    return LdapAdmin::Administration.get_all_users
  end

  def self.find_groups(dn)
    return LdapAdmin::Administration.get_user_groups(:dn => dn)
  end

end
