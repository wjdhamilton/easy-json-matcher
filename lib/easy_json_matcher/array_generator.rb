module EasyJSONMatcher
  class ArrayGenerator

    WHITELIST = [:required, :not_required]

    attr_reader :opts, :content_opts, :target_class

    def initialize(local_opts:, global_opts:, target_class: ArrayValidator)
      @target_class = target_class
      @opts = extract_opts(locals: local_opts, globals: global_opts)
      @content_opts = []
    end

    def generate_array
      target_class.new(opts: opts, verify_content_as: content_opts)
    end

    def elements_should(be:)
      @content_opts = be
    end

    def extract_opts(locals:, globals:)
      (globals.select(&array_options_filter) + locals).map(&override_local_values(locals: locals))
    end

    def array_options_filter
      ->(opt) { WHITELIST.include?(opt) }
    end

    def override_local_values(locals:)
      conflicts = { required: :not_required }
      ->(opt) { 
        if conflicts.keys.include? opt
          locals.include?(conflicts[opt]) ? conflicts[opt] : opt
        else
          opt
        end
      }
    end
  end
end
