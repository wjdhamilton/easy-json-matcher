module EasyJSONMatcher

  # Class which is used to convert a node to a human-readable format for 
  # inspection purposes.

  class Printer

    attr_reader :n

    def initialize(node:)
      @n = node
    end

    def inspect
      root_flag = "root: "
      root_flag + pretty_print(n.validation_chain, root_flag.length)
    end

    def pretty_print(node, n)
      depth = grow_s(n)
      d = n + 1
      case node
      when Node
        pretty_print node.node_validator, n
      when Validator
        pretty_print node.validation_chain, n
      when ArrayValidator
        pretty_print node.verifier, n
      when ArrayContentValidator
        pretty_print node.verifier, n
      when ValidationRule
        node.type.to_s
      when ValidationStep
        head = pretty_print node.verifier, d
        tail = pretty_print node.next_step, n unless node.is_tail?
        tail_string = tail ? "\n#{depth}#{tail}" : ""
        "#{head} | #{tail_string}"
      when ValidatorSet
        parts = node.validators.each_with_object([]) do |k_v, out|
          key_padding = d + k_v[0].length + 1
          out << "#{k_v[0]}: #{pretty_print k_v[1], key_padding}\n"
        end
        parts.join(depth)
      else
        throw Error.new(node.class.to_s)
      end
    end

    def grow_s(n)
      buffer = ""
      n.times { buffer << " " }
      buffer
    end
  end
end
