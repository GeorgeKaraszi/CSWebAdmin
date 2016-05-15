class Request


  #
  # Output:
  #    [{:title, :description, :type, :key, :val, :required}, ...]
  #
  # Title: Title of the attribute
  # Description: Information about the attribute
  # Type: Field type(Number, String, etc..)
  # Key: Actual attribute key name used on the LDAP server
  # (optional) Value: Existing value for the given attribute that the LDAP entry has
  # (optional) Required: Indicates if a given attribute is required for an entry
  #
  # Returns a list containing attributes that have already been assigned to the LDAP
  # entry. And attributes that are available for the LDAP entry.
  ###################################################################################
  def self.attribute_query(ldap_entry, ou)

    request_hash               = Array.new
    query                      = query_fields(ou)
    attribute_list             = ldap_entry.attributes.keys.select { |k| k if k != 'objectClass' }
    query_available_attributes = select_fields(query).where.not('attribute_names.keyattribute' => attribute_list)


    ldap_entry.attributes.each do |key, value|
      query_results = select_fields_where(query, 'attribute_names.keyattribute' => "#{key}").first
      values = (value.kind_of?(Array) ? value : Array(value))

      values.each do |element|
        unless query_results == nil
          hash_input = {
              :title       => query_results.title,
              :description => query_results.description,
              :type        => query_results.field_type,
              :key         => query_results.keyattribute,
              #enum => entry.enum   -- Add this once value restrictions are in place (select and radio buttons)
              :val         => element
          }

          request_hash.push(hash_input)
        end
      end
    end

    query_available_attributes.each do |entry|
      hash_input = {
          :title       => entry.title,
          :key         => entry.keyattribute,
          :description => entry.description,
          #enum => entry.enum   -- Add this once value restrictions are in place
          :type        => entry.field_type,
          :required    => entry.required
      }

      request_hash.push(hash_input)
    end

    request_hash
  end


  private

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

  def self.select_fields_where(query, where_clause)
    query.select('attribute_names.title, attribute_names.keyattribute, attribute_names.description, ' +
                     'attribute_fields.field_type, attribute_fields.required').where(where_clause)
  end

  def self.select_fields(query)
    query.select('attribute_names.title, attribute_names.keyattribute, attribute_names.description, ' +
                     'attribute_fields.field_type, attribute_fields.required')
  end

end