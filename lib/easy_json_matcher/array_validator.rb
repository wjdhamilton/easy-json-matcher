require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class ArrayValidator 

    attr_reader :next_step, :verifier, :chain

    def check(value:, errors: [])
      errors = []
      errors << "Is not an array" and return errors unless value.is_a? Array
      value.each { |elem| errors << chain.check(elem, errors) }
      errors
    end
  end
end
