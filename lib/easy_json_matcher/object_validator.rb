require 'easy_json_matcher/validator'
module JSONAPIMatcher
  class ObjectValidator < Validator
    def _validate
      content.is_a? Hash
    end
  end
end
