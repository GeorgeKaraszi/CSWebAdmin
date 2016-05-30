class LdapBase < ActiveLdap::Base

  #
  # Returns a json hash model to the requesting api
  ###################################################################################

  def self.json_model(entries)
    if entries.kind_of?(Array)
      return entries.map do |hash|
        {dn: "#{hash['dn']}", cn: hash.cn, attributes:hash.attributes}
      end
    else
      return {dn:"#{entries['dn']}", cn: entries.cn, attributes:entries.attributes}
    end
  end


  # Processes all parameters that have been submitted and checks to see if any
  # additions or changes have been made to the LDAP record
  ##################################################################################
  def save(hash_params)

    if hash_params['objectClass']
      submitted_object = hash_params['objectClass'].delete(' ').split(',')
      remove_objects = objects_to_remove(submitted_object)
      add_objects = objects_to_add(submitted_object)
      hash_params.delete('objectClass')

      remove_objects.each {|o| self.remove_class(o) }
      add_objects.each {|o| self.add_class(o) }
    end

    hash_params.each {|key, value| self[key] = value }
    self.save!
  rescue => e
    false
  end


  def error_message
    msg = []
    self.errors.messages.each do |k,v|
      v.each do |e|
        msg.push("#{k} #{e}")
      end
    end
    msg
  end


  def objects_to_remove(submitted_objects)
    self_objects = self.attributes['objectClass']
    related_objects =  self_objects & submitted_objects

    self_objects.select {|o| !related_objects.include?(o)}
  end

  def objects_to_add(submitted_objects)
    self_objects = self.attributes['objectClass']
    related_objects =  self_objects & submitted_objects

    submitted_objects.select {|o| !related_objects.include?(o)}
  end

  private
  #
  # Performs the actual ldap modification
  ###################################################################################
  def attribute_update(key, original, modified)
    case key.downcase
      when 'objectclass'
        self.remove_class(original) if modified.blank?
        self.add_class(modified) if original.blank?
      when 'userpassword'
        self[key] = ActiveLdap::UserPassword.ssha(modified)
      else
        self[key] = modified
    end
  end

end