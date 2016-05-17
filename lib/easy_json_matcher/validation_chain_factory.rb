require "easy_json_matcher/validation_step"
require "easy_json_matcher/unknown_validation_step_error"

module EasyJSONMatcher
  class ValidationChainFactory

    class << self
   
      def get_chain(steps:, of: ValidationStep)
        head = create_head_for(steps: steps, step_type: of)
        assemble_chain(head: head, steps: steps, step_type: of)
        head
      end

      def assemble_chain(head:, steps:, step_type:)
        steps.inject(head) do |last_link, step|
          last_link >> get_step_for(validating: step, using: step_type)
        end
      end
      
      def create_head_for(steps:, step_type:)
        is_required = steps.include?(:required)
        get_step_for validating: is_required ? :required : :not_required, using: step_type
      end

      def get_step_for(validating:, using: ValidationStep)
        if validating.respond_to? :call
          using.new verify_with: validating
        elsif verifier = standard_validator(with: validating)
          using.new verify_with: verifier
        else
          raise UnknownValidationStepError.new(type: validating)
        end
      end

      def standard_validator(with:)
        require "easy_json_matcher/validation_rules"
        VALIDATION_RULES[with]
      end
    end
  end
end
