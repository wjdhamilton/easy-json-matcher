require 'jsonapi_matcher/validator'
module JSONAPIMatcher
  class ArrayValidator < Validator
    def _validate
      json.is_a? Array
    end
  end
end
