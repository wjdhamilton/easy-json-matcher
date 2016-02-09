require 'jsonapi_matcher'
module JSONAPIMatcher
  class BooleanValidator < Validator
    def _validate
      clazz = json.class
      (clazz == TrueClass) || (clazz == FalseClass)
    end
  end
end
