require "easy_json_matcher/array_validator"
require "easy_json_matcher/validation_step"
require "easy_json_matcher/unknown_validation_step_error"

module EasyJSONMatcher
  class ValidationChainFactory

    class << self
   
      def get_chain(steps:)
        head = create_head_for(steps: steps)
        assemble_chain(head: head, steps: steps)
        head
      end

      def assemble_chain(head:, steps:)
        steps.inject(head) do |last_link, step|
          last_link >> get_step_for(validating: step)
        end
      end

      
      def create_head_for(steps:)
        if steps.delete(:required)
          get_step_for(validating: :required)
        else
          get_step_for(validating: :not_required)
        end
      end

      def get_step_for(validating:)
        if validating.respond_to? :call
          new_step(verifier: validating) 
        elsif validating.is_a? Symbol
          choose_standard_validator with: validating
        else
          raise UnknownValidationStepError.new(type: validating)
        end
      end

      def choose_standard_validator(with:)
        require "easy_json_matcher/validation_rules"
        new_step(verifier: VALIDATION_RULES[with])
      end

      def new_step(verifier:)
        ValidationStep.new(verify_with: verifier)
      end
    end
  end
end
