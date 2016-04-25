module ApplicationHelper

  def to_array_helper(input)
    input.kind_of?(Array) ? input : Array(input)
  end

  def link_to_add_fields(name, export_path, ouname)
    link_to(name, '#', class: 'add_fields', data: {url: export_path, ou: ouname})
  end

end
