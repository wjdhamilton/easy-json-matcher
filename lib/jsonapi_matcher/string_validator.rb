module JSONAPIMatcher
  class StringValidator < Validator

  def _validate
    json.is_a? String  
  end

  end
end
