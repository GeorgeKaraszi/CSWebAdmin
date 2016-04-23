class LdapUser < ActiveLdap::Base
ldap_mapping dn_attribute: 'uid',
             prefix: 'ou=People'

  def to_model
    self
  end

  def update_ldap(hash_params)
    ret = true
    hash_params.each do |key, value|
      value.each do |original, modified|
        attribute_update(key,original,modified) if original != modified
      end
    end
    self.save
  end

  private
  def attribute_update(key, original, modified)
    case key
      when 'objectClass'
        self.remove_class(original) if modified.blank?
        self.add_class(modified) if original.blank?
      else
        self[key] = modified
    end
  end

end