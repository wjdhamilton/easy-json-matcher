require 'easy_json_matcher/validator'
module JSONAPIMatcher
  class StringValidator < Validator

  def _validate
    content.is_a? String
  end

  end
end
