require 'jsonapi_matcher/validator'
module JSONAPIMatcher
  class DateValidator < Validator

    attr_reader :string_validator, :date_format
    DEFAULT_DATE_FORMAT = "%Y-%m-%d"

    def initialize(opts = {})
      super(opts)
      @date_format = opts[:format]
      @string_validator = ValidatorFactory.create({type: :string})
    end

    def _validate
      _validate_as_string && _validate_as_date
    end

    def _validate_as_string
      string_validator.valid? content
    end

    def _validate_as_date
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
  end
end
