require 'easy_json_matcher/validator'
module EasyJSONMatcher
  class DateValidator < Validator

    attr_reader :string_validator, :date_format
    DEFAULT_DATE_FORMAT = "%Y-%m-%d"

    def initialize(opts = {})
      super(opts)
      @date_format = opts[:format]
      @string_validator = _create_validator(type: :string)
    end

    def _validate(candidate)
      _validate_string(candidate)
      _validate_date(candidate) if _no_errors?
    end

    def _candidate_is_a_string?(candidate)
      string_validator.valid? candidate
    end

    def _candidate_is_a_date?(candidate)
      require 'date'
      begin
        Date.strptime(candidate, date_format)
      rescue ArgumentError
        false
      end
    end

    def date_format
      @date_format || DEFAULT_DATE_FORMAT
    end

    def _validate_string(candidate)
      errors << "#{candidate} must be provided as a String for Date validation" unless _candidate_is_a_string?(candidate)
    end

    def _validate_date(candidate)
      errors << "#{candidate} is not a Date" unless _candidate_is_a_date?(candidate)
    end
  end
end
