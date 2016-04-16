require 'ldap/admin'

class Ldap < ActiveRecord::Base

  def self.find_by_dn(dn)
    return LdapAdmin::Administration.find(:dn => dn)
  end
end