class LdapUser < ActiveLdap::Base
ldap_mapping dn_attribute: 'uid',
             prefix: 'ou=People'

  #
  # Output:
  #    [{description:**, field_type:**, keyattribute:**, values:[**,**]}, ...]
  #
  # Returns a list of attributes the user has already defined
  ###################################################################################
  def current_attributes
    reqHash = Array.new
    query = LdapUser.query_fields('People')
    values = []

    self.attributes.each do |key,value|
      queryRes = LdapUser.select_fields_where(query, 'attribute_names.keyattribute' => "#{key}").first

      unless queryRes == nil
        hashResults = {
            :description => queryRes.description,
            :field_type => queryRes.field_type,
            :keyattribute => key,
            :values => (value.kind_of?(Array) ? value : Array(value))
        }

          reqHash.push(hashResults)
      end
    end

    reqHash
  end

  #
  # Returns a model used by rails form builder
  ###################################################################################
  def to_model
    self
  end

  #
  # Returns all the available attributes a new user can have
  ###################################################################################
  def self.available_attributes(att_name)
    query = query_fields(att_name)
    select_fields(query)
  end


  #
  # Returns all the available attributes that THIS user can have
  ###################################################################################
  def available_attributes(att_name)
    attribute_list = self.attributes.keys.select {|k| k if k != 'objectClass'}
    query = LdapUser.query_fields(att_name)
    if attribute_list.blank?
      LdapUser.select_fields(query)
    else
      LdapUser.select_fields(query).where.not('attribute_names.keyattribute' => attribute_list)
    end

  end



  #
  # Processes all parameters that have been submitted and checks to see if any
  # additions or changes have been made to the LDAP record
  ###################################################################################
  def update_ldap(hash_params)

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
  def self.query_fields(type_name)
    AttributeField.joins(:attribute_type, :attribute_name).where("attribute_types.name = '#{type_name}' ")
  end

  #
  # Standard definition for what attributes we want to know about
  ###################################################################################
  def self.select_fields(query)
    query.select('attribute_names.keyattribute, attribute_names.description, ' +
                     'attribute_fields.field_type, attribute_fields.required')
  end

  def self.select_fields_where(query, where_clause)
    query.select('attribute_names.keyattribute, attribute_names.description, ' +
                   'attribute_fields.field_type, attribute_fields.required').where(where_clause)
  end


end