class Thing
  def method_missing(method, * args)
    if method.to_s[0..2] == "to_"
      "i am #{method.to_s[3..-1]}"
    else
      super
    end
  end
  
end

this = Thing.new
p this.to_batman