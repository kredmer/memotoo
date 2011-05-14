module Kernel # :nodoc: all
private
   def this_method
    caller[0] =~ /`([^']*)'/ and $1
  end
  def calling_method
    caller[1] =~ /`([^']*)'/ and $1
  end
end

