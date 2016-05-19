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

end
