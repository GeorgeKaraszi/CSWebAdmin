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

  #
  # Processes all parameters that have been submitted and checks to see if any
  # additions or changes have been made to the LDAP record
  ###################################################################################
  def save(hash_params)

    hash_params.each do |key, value|
      case key
        when 'new'
          value.each do |key, value|
            attribute_update(key, value, value) unless value.blank?
          end
        else
          value.each do |original, modified|
            attribute_update(key, original, modified) if original != modified
          end
      end
    end
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