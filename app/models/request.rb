class Request

  def self.request_by(param_hash)
    case param_hash['type']
      when 'attribute_request'
        self.attribute_request(param_hash)
      else
        false
    end
  end


  private
  def self.attribute_request(param_hash)
    query = AttributeField.joins(:attribute_type).where("attribute_types.name = '#{param_hash['name']}' ")
     if param_hash.key?('exclude')
       query.select(:keyattribute, :field_type).where.not(:keyattribute => param_hash['exclude'])
     else
       query.select(:keyattribute, :field_type)
     end
  end

end