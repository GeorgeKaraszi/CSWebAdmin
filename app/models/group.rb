require 'ldap/admin'

class Group < ActiveRecord::Base

  def self.all_groups
    return  LdapAdmin::Administration.get_all_groups
  end

end
