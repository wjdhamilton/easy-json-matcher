require 'json_matcher/validator'
module JSONAPIMatcher
  class ArrayValidator < Validator
    def _validate
      content.is_a? Array
    end
  end
end
