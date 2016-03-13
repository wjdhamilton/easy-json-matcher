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

    def _validate
      _content_is_a_string? && _content_is_a_date?
    end

    def _content_is_a_string?
      string_validator.valid? content
    end

    def _content_is_a_date?
      require 'date'
      begin
        Date.strptime(content, date_format)
      rescue ArgumentError
        false
      end
    end

    def date_format
      @date_format || DEFAULT_DATE_FORMAT
    end

    def _explain_errors
      errors << "#{content} must be provided as a String for Date validation" unless _content_is_a_string?
      errors << "#{content} is not a Date" unless _content_is_a_date?
    end
  end
end
