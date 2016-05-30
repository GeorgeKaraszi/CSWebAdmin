class LdapUser < LdapBase
  ldap_mapping :dn_attribute => 'uid',
               :prefix  =>  'ou=People',
               :classes => ['inetOrgPerson', 'posixAccount']

  #
  # Reruns a hash array of all the entries mapped out with essential identification
  ###################################################################################
  def self.all!(entry_list)
    entry_list.inject([]) do |arr, entry|
      arr << {dn: "#{entry['dn']}", cn: entry.cn, idNum:entry['uidNumber']}
      arr
    end
  end

  #
  # Creates the user with the necessary input required before being
  # allowing to add additional attributes
  ###################################################################################
  def self.new_entry(hash_params)
    if hash_params[:userPassword]
      unless hash_params[:userPassword].include? '{SSHA}'
        hash_params[:userPassword] = ActiveLdap::UserPassword.ssha(hash_params[:userPassword])
      end
    end

      LdapUser.new(hash_params[:uid]) unless hash_params[:uid].nil?

  end

end
