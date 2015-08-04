################################## 
  
how this works
  
################################## 
  
################################## 
  
i dont know 
  
################################## 
  
#require 'pry'
  
BEGIN{ 
  def self.method_missing name, *a 
    (@message ||= []) << name 
  end
  class << self; alias const_missing method_missing end
} 
  
#binding.pry 
  
@message.reverse * ' '
  
##################################