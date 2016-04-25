class Request

  def self.request_by(param_hash)
    case param_hash[:type]
      when 'attribute_request'
        self.attribute_request(param_hash)
      else
        false
    end
  end


  private
  def self.attribute_request(param_hash)
    #query = AttributeField.joins(:attribute_type).where(:name => param_hash[:name])
    #attribute_type = AttributeType.find_by(name: param_hash[:name]).id
    query = AttributeField.joins(:attribute_type).where("attribute_types.name = '#{param_hash[:name]}' ")
    #query = AttributeField.joins(:attribute_types).where(attribute_type_id: attribute_type)
     if param_hash.key?(:excludes)
       excludeList = JSON.parser(param_hash[:exclude])
       query.select(:keyattribute, :field_type).where.not(:keyattribute => excludeList)
     else
       query.select(:keyattribute, :field_type)
     end
  end

end