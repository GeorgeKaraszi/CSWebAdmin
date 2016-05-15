class LdapUser < LdapBase
  ldap_mapping :dn_attribute => 'uid',
               :prefix  =>  'ou=People',
               :classes => ['inetOrgPerson', 'posixAccount']

  #
  # Creates the user with the necessary input required before being
  # allowing to add additional attributes
  ###################################################################################
  def self.new_entry(hash_params)
    new_params = hash_params['new']
    return LdapUser.new(new_params['uid']) unless new_params['uid'].blank?
  end

end