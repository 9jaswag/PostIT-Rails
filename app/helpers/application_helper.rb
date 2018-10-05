module ApplicationHelper
  # return the bootstrap color class to match message priority
  def message_priority(priority)
    if priority == 'normal'
      'primary'
    elsif priority == 'urgent'
      'warning'
    else
      'danger'
    end
  end
end
