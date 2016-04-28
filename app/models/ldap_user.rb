class LdapUser < ActiveLdap::Base
ldap_mapping dn_attribute: 'uid',
             prefix: 'ou=People'



  #
  # Returns a list of attributes the user has already defined
  ###################################################################################
  def current_attributes
    self.attributes.keys.select {|k| k if k != 'objectClass'}
  end

  #
  # Returns a model used by rails form builder
  ###################################################################################
  def to_model
    self
  end

  #
  # Returns all the available attributes a user can have
  ###################################################################################
  def self.available_attributes(att_name)
    query = select_fields(att_name)
    query.select(:keyattribute, :field_type, :required)
  end


  #
  # Returns all the available attributes that THIS user can have
  ###################################################################################
  def available_attributes(att_name)
    attribute_list = current_attributes
    query = LdapUser.select_fields(att_name)
    if attribute_list.blank?
      query.select(:keyattribute, :field_type, :required)
    else
      query.select(:keyattribute, :field_type, :required).where.not(:keyattribute => attribute_list)
    end

  end

  #
  # Processes all parameters that have been submitted and checks to see if any
  # additions or changes have been made to the LDAP record
  ###################################################################################
  def update_ldap(hash_params)
    ret = true
    hash_params.each do |key, value|
      case key
        when 'new'
          value.each do |key, value|
            attribute_update(key, value, value) unless value.blank?
          end
        else
          value.each do |original, modified|
            attribute_update(key,original,modified) if original != modified
          end
      end
    end
    #self.save
  end

  private
  #
  # Performs the actual ldap modification
  ###################################################################################
  def attribute_update(key, original, modified)
    case key
      when 'objectClass'
        self.remove_class(original) if modified.blank?
        self.add_class(modified) if original.blank?
      else
        self[key] = modified
    end
  end

  #
  # Communicants with the database to select all possible attributes for a given OU
  # and their field types
  ###################################################################################
  def self.select_fields(type_name)
    AttributeField.joins(:attribute_type).where("attribute_types.name = '#{type_name}' ")
  end

end