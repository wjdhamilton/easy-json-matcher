# JSONAPIMatcher
This project rocks (well, hopefully!) and uses MIT-LICENSE.

version 0.0.0

This gem will assist developers who want to test that their API conforms to the JSONAPI schema (http://jsonapi.org/format/). 

Basically, the idea is as follows: 

* Create a schema template to match the intended output of your JSONApi
* Create an integration test that calls your api
* Check that the response complies with the schema.

This means that the developer should only have to create a template that specifies what the api should produce, and then test that it does. 

The matcher should ensure that all the JSONApi standards are adhered to.

The gem should also allow the nesting of schemas, to avoid code reuse. 


Take the example response from the JSONAPi website's front page:

```ruby
JSONAPIMatcher::Schema.new :article do
   
    links :true 

    data do
	attributes {title: {type: :string, mandatory: :true}}
        relationships [:author, :comments]
        include_links? true
    end

    included [:people, :comments]
end

```
The type could be inferred from the first argument passed to `JSONApiSchema.new`.
