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
  def self.attribute_query(entry)
    must = must_have(entry)
    may = unique(may_have(entry), must, :key)
    attribute = entry.attributes


    request = attribute.inject([]) do |arr, (key,element)|
      value = element unless element.is_a?(Array)
      value ||= element.join(',')

      index = must.find_index {|e| e[:key] == key}
      hash_insert = must.delete_at(index) unless index.nil?
      hash_insert ||= may.delete_at(may.find_index {|e| e[:key] == key})

      unless hash_insert.nil?
        hash_insert[:val] = value
        arr.push(hash_insert)
      end

      arr
    end

    request += must unless must.empty?
    request += may unless may.empty?
    request
  end

  #
  # Returns a new array containing unique hash elements that are compared by a key
  # value
  ###################################################################################
  def self.unique(target, source, key)

    target.inject([]) do |arr, e|
      list = source.select {|s| s[key] == e[key]}
      arr.push(e) if list.empty?
      arr
    end

  end

  #
  # Returns an array of hashes containing attributes the entry requires
  ###################################################################################
  def self.must_have(entry)
    collect_attributes(entry, entry.must).inject([]) do |arr, element|
      element[:required] = true
      arr.push(element)
      arr
    end

  end

  #
  # returns an array of hashes containing attributes the entry 'could' use
  ###################################################################################
  def self.may_have(entry)
    collect_attributes(entry, entry.may)
  end

  private

  #
  # returns an array of hashes containing a list of attributes that are matched
  # defined the associated database
  ###################################################################################
  def self.collect_attributes(entry, collection)
    attribute_list = collection.collect {|k| k.name.to_s}
    query = query_fields(entry)
    query = select_fields_where(query, 'attribute_names.keyattribute' => attribute_list)

    query_hash = query.inject({}) do |hash,value|
      hash[value.keyattribute] = {d: value.description, a: value.title, f: value.field_type}
      hash
    end

    collection.inject([]) do |arr, value|
      unless query_hash[value.name].nil?
          arr.push({
                       key: value.name,
                       title: query_hash[value.name][:a],
                       description: query_hash[value.name][:d],
                       type: query_hash[value.name][:f]
                   })
      end

      arr
    end
  end

  #
  # Communicants with the database to select all possible attributes for a given OU
  # and their field types
  ###################################################################################
  def self.query_fields(entry)
    ou = entry.base.rdns.first['ou']
    AttributeField.joins(:attribute_type, :attribute_name).where("attribute_types.name = '#{ou}' ")
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