module AttributeTypeMethods

    def has_boolean(key:, opts: [])
      has_attribute(key: key, opts: opts + [:boolean])
    end

    def has_number(key: , opts: [])
      has_attribute(key: key, opts: opts + [:number] )
    end

    def has_date(key:, opts: [])
      has_attribute(key: key, opts: opts + [:date])
    end

    def has_object(key:, opts: [])
      has_attribute(key: key, opts: opts + [:object])
    end

    def has_value(key:, opts: [])
      has_attribute(key: key, opts: opts + [:value])
    end

    def has_string(key:, opts: [])
      has_attribute(key: key, opts: opts + [:string])
    end

    def has_strings(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_string)
    end

    def has_booleans(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_boolean)
    end

    def has_numbers(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_number)
    end

    def has_objects(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_object)
    end

    def has_values(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_value)
    end

    def has_dates(keys:, opts: [])
      mass_assign(keys: keys, opts: opts, meth: :has_date)
    end


    def mass_assign(keys:, opts: [], meth:)
      keys.each { |k| self.send(meth, { key: k, opts: opts }) }
    end
end
