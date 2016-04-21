class LdapGroup < ActiveLdap::Base
  ldap_mapping dn_attribute: "cn",
               prefix: "ou=Groups"


end
