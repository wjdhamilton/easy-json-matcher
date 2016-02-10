require 'jsonapi_matcher/validator'
module JSONAPIMatcher
  class ObjectValidator < Validator
    def _validate
      json.is_a? Hash
    end
  end
end
