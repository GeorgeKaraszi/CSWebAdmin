module ApplicationHelper

  def to_array_helper(input)
    input.kind_of?(Array) ? input : Array(input)
  end

  def link_to_add_fields(name, export_path, ouname, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: {url: export_path, ou: ouname, id: id, fields: fields.gsub('\n','')})
  end

end
