module ApplicationHelper

  def to_array_helper(input)
    input.kind_of?(Array) ? input : Array(input)
  end

end
