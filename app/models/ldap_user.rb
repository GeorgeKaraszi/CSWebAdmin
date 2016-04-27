class LdapUser < ActiveLdap::Base
ldap_mapping dn_attribute: 'uid',
             prefix: 'ou=People'


def my_exclude
  self.attributes.keys.select {|k| k if k != 'objectClass'}
end

  def to_model
    self
  end

  def available_attributes(att_name)
    excludeList = my_exclude
    query = AttributeField.joins(:attribute_type).where("attribute_types.name = '#{att_name}' ")

    if excludeList.blank?
      query.select(:keyattribute, :field_type)
    else
      query.select(:keyattribute, :field_type).where.not(:keyattribute => excludeList)
    end

  end



  def update_ldap(hash_params)
    ret = true
    hash_params.each do |key, value|
      value.each do |original, modified|
        #attribute_update(key,original,modified) if original != modified
      end
    end
    #self.save
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