module ApplicationHelper
  
  def hide_if_nil(value)
    if value.nonzero?
      value
    else
      "-"
    end
  end
end
