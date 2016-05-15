require "easy_json_matcher/array_validator"
require "easy_json_matcher/validation_step"

#TODO Is this class in use any more?

module EasyJSONMatcher
  class ValidatorFactory

    class << self
      def get_instance(type:, opts: {})
        if type == :schema
          SchemaLibrary.get_schema(name: opts[:name], opts: opts)
        elsif type == :array
          ArrayValidator.new
        else
          validation_steps = get_val_steps(type: type, opts: opts)
          chain = create_validator_chain(steps: validation_steps)
          Validator.new(options: { validate_with: chain })
        end
      end

      def get_val_steps(type:, opts:)
        steps = []
        # steps << :required if opts[:required]
        steps << type
        # steps << opts[:custom_validator] if opts[:custom_validator]
        steps
      end

      def create_validator_chain(steps:)
        steps = prioritise_steps(steps: steps)
        head = create_step(type: steps.pop)
        steps.inject(head) { |type, prior| prior >> create_step(type: type) }
      end

      def prioritise_steps(steps:)
        steps
      end

      def create_step(type:)
        case type
        when :object
          new_verification_step verifier: object_validator
        when :string
          new_verification_step verifier: string_validator
        when :number
          new_verification_step verifier: number_validator
        when :date
          string_val = new_verification_step(verifier: string_validator) 
          string_val >> new_verification_step(verifier: date_validator)
          string_val
        when :boolean
          new_verification_step(verifier: boolean_validator)
        when :value
          new_verification_step(verifier: value_validator)
        else
          raise "Type must be specified" 
        end
      end

      def new_verification_step(verifier:)
        ValidationStep.new(verify_with: verifier)
      end

      def type_to_const(type:)
        const_name = type.to_s.titleize
        Kernel.const_get(const_name)
      end

      def object_validator
        lambda do |value, errors|
          unless value.is_a? Hash
            errors << "#{value} is not an Object"
            return false
          end
        end
      end

      def string_validator
        lambda do |value, errors|
          unless value.is_a? String
            errors << "#{value} is not a String"
            return false
          end
        end
      end

      def number_validator
        lambda do |value, errors|
          error_message = "#{value} is not a Number"
          begin
            Kernel::Float(value)
          rescue ArgumentError, TypeError
            errors << error_message
            false
          end
        end
      end

      def date_validator
        require "date"
        lambda do |value, errors|
          error_message = "#{value} is not a valid SQL date"
          begin
            Date.strptime(value,"%Y-%m-%d")
          rescue ArgumentError
            errors << error_message
          end
        end
      end

      def boolean_validator
        lambda do |value, errors|
          clazz = value.class
          unless (clazz == TrueClass) || (clazz == FalseClass)
            errors << "#{value} is not a Boolean"
            false
          end
        end
      end

      def array_validator
        ArrayValidator.new
      end

      def value_validator
        lambda do |value, errors|
          true
        end
      end
    end
  end
end
