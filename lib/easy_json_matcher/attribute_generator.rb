module EasyJSONMatcher
  class AttributeGenerator
    include AutoInject.kwargs[:chain_factory]

    attr_reader :opts, :factory

    def initialize(local_opts:, global_opts:, **args)
      super
      @opts = extract_opts(locals: local_opts, globals: global_opts)
    end

    def generate_attribute
      chain_factory.get_chain(steps: opts)
    end

    def extract_opts(locals:, globals:)
      (globals.reject(&non_attribute_options_filter) + locals).map(&override_local_values(locals: locals))
    end

    #TODO this method should whitelist the options, and the options should be in a constant
    # Remember to change extract_ops so that it uses globals.select afterwards
    def non_attribute_options_filter
      non_attribute_options = [:strict]
      ->(opt) { non_attribute_options.include? opt }
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
