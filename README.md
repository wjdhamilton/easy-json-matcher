#EasyJSONMatcher

This gem is designed to make it easy for you to validate JSON objects in Ruby.

The interface uses a plain Ruby DSL to make representing expected JSON output in your test suites very straightforward. No need to work in any other language or even create additional files to store your schemas if you don't want to.  

version 0.0.4

##Installation

`gem install easy_json_matcher`

or add

`gem 'easy_json_matcher'`

to your gemfile.


##SchemaGenerator
`EasyJSONMatcher::SchemaGenerator` is responsible for providing the client interface. Use it to define your schemas.

To create a new schema for validating against your JSON objects, create a SchemaGenerator object and pass in a block which defines the expected content of your JSON:

```ruby
expected = EasyJSONMatcher::SchemaGenerator.new {|json_schema|
    # Validation logic here
}
```

Using curly braces is preferable to `do...end` since the new `SchemaGenerator` object defines a couple of messages for retrieving the `Validator` object which you'll use to validate your schema. These messages are: `generate_schema` which returns an instance of `Node` that you can use to validate JSON objects by calling `node.valid? json`, or `register as: :schema_name` which registers the schema with `SchemaLibrary` for future use and also returns the node as above.

###Defining your schema

####Primitives

The `SchemaGenerator` interface provides a series of messages which you can use to define your schema. The simplest of these define expected primitive values as follows:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|json_schema|
    json_schema.has_number  key: :number
    json_schema.has_boolean key: :boolean
    json_schema.has_string  key: :string
    json_schema.has_value   key: :value
    json_schema.has_object  key: :object
}
  ```

Which would correctly validate the below JSON string:

```json
"{
  'number': 1,
  'boolean': true,
  'string': 'EasyJSONMatcher',
  'value': null,
  'object': {}
}"
```
The `#has_object` message only defines a key/value pair where the value is an arbitrary json object. For defining schemas that include the details of nested objects see the section below on `#has_schema` or the section on `#contains_node`.

####Dates
Although dates are not part of the JSON specification, they are commonly used in JSON payloads and so a validator is available using the `#has_date` method. It is used as follows:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|json_schema|
  json_schema.has_date key: :date
}
```

which would validate the following json object:

```json
"{
  date: '2016-03-04'
}"
```

EasyJSONMatcher currently only supports dates in the SQL format, i.e. YYYY-MM-DD.

###Describing complex objects

`SchemaGenerator` messages which begin with `#contains_` take blocks which allow you to describe attributes on complex nested objects and arrays.

####Arrays

JSON payloads can contain arrays, which have to be handled differently from primitive values. A JSON array can contain values of types equal to any or all of the above primitives. Therefore `#contains_array` allows you to define the type of values that an object should contain by yielding an object to a block which responds to a series of methods prefixed with `#should_only_contain{type}`:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|array_schema|
  array_schema.contains_array key: :array do |array|
    array.should_only_contain_strings
  end
}
```

Allowing clients to specify that there can be values of different types may be implemented in future releases.

You can also reuse registered schemas in almost the same manner, using the `#should_only_contain_schema` as follows:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|array_schema|
  array_schema.should_only_contain_schema name: :schema_name
}
```

####Objects

JSON objects can contain nested objects. These can be defined in the schema in two different ways, either by defining them inline with `#contains_node` or using `#has_schema`.

#####contains_node
`#contains_node` yields an object that responds to the same messages as `SchemaGenerator`, so you can define the content of the expected object in the same way that you define the content of your top-level `SchemaGenerator` instance. For instance:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|node_schema|
  node_schema.contains_node key: :level_1 do |level_1|
    node.has_string key: :title
    node.contains_node key: :level_2 do |level_2|
      node.has_string: :title
    end
  end
}
```
...would validate the following json object:

```json
"{
  'level_1': {
    'title': 'level one',
    'level_2': {
      'title': 'level two'
    }
  }
}"
```

#####has_schema
`has_schema` allows the user to reuse a schema that has already been registered with the `SchemaLibrary`. The message accepts two arguments, the key and the name as follows:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|reusable|
  reusable.has_string key: :name
}.register as: :reusable

EasyJSONMatcher::SchemaGenerator.new {|schema|
  schema.has_schema key: :reused_schema, name: :reusable
}
```

will validate the following json object:

```json
"{
  'reused_schema': {
    'name': 'Reusable'
  }
}"
```

###Options
All the messages that define the content of a schema can accept an options hash with the keyword `:opts`, for instance:

```ruby
schema.has_string key: :string, opts: {required: true}
```

This applies to methods prefixed with both `has_` and `contains_`.

The options accepted by all validators are as follows:

*`required:` indicates that the value must be present. Note that has_value will accept `null` as a value in this case, but the key must be present in the JSON object.*

##Validation
Once you have defined your schema, you can retrieve the generated validator using `#generate_schema`. The object that is returned responds to the `#valid?` method to which you pass your JSON object. It will return `true` iff the object complies with the schema:

```ruby
schema = EasyJSONMatcher::SchemaGenerator.new {|schema|
  #define the schema
}.generate_schema

schema.valid? json
```

##Reusing Schemas
Any schema can be registered with the `SchemaLibrary` object, by sending the `#register` message to an instance of `SchemaGenerator`. Doing so explicitly registers the schema's `Validator` with `SchemaLibrary` and also returns the generated `Validator`. So you can do the following:

```ruby
EasyJSONMatcher::SchemaGenerator.new {|schema|
  #define the schema
}.register as: :saved_schema

retrieved = EasyJSONMatcher::SchemaLibrary.get_schema name: :saved_schema

validity = retrieved.valid? json
```

You can also add a schema directly using `EasyJSONMatcher::SchemaLibrary#add_schema` if you wish.

##Issues
If you find any aspect of the gem which does not behave as expected, please raise an issue. If the issue relates specifically to a JSON payload validating incorrectly for a given schema, please supply both the code you used to create the schema and the object that did not validate in your bug report. That will make it much easier to track down the issue!

##Contributing
I hope you find this gem useful. Please feel free to create an issue if you would like to suggest an enhancement, and then it would be great if you could implement a patch and submit a pull request too!
