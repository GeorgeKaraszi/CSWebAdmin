class LdapGroup < LdapBase
  ldap_mapping dn_attribute: "cn",
               prefix: "ou=Groups",
               :classes => ['top', 'posixGroup']

#
# Reruns a hash array of all the entries mapped out with essential identification
###################################################################################
  def self.all!(entry_list)
    entry_list.inject([]) do |arr, entry|
      arr << {dn: "#{entry['dn']}", cn: entry.cn, idNum:entry['gidNumber']}
      arr
    end
  end

#
# Creates the user with the necessary input required before being
# allowing to add additional attributes
###################################################################################
  def self.new_entry(hash_params)
    new_params = hash_params['new']
    return LdapGroup.new(new_params['cn']) unless new_params['cn'].blank?
  end

end
