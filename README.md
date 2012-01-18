# Dive: for deep hash access

Dive is a gem for accessing values within nested Hashes.

Why? Well, it all started when I was mapping human readable names taken from a Cucumber table to fields in a JSON response:

```cucumber
Given I have some sausages with
  | Name          | Contents                      |
  | Pork + Fennel | pork mince, fennel, intestine |
  | Soylent Green | people                        |  
```

```ruby
Given /^I have some sausages with$/ |table|
  fields = {
    'Name' => :name,
    'Contents' => :ingredients
  }
  table.hashes.each do |row|
    sausage = {} 
    row.each_pair do |key, value|
      sausage[fields[key]] = value
    end
    @response[:sausages] << sausage
  end
end
```

```ruby
@response
{ 
  :sausages => [
    {
	  :name => 'Pork + Fennel'
      :ingredients => 'pork mince, fennel, intestine'
    },
    {
	  :name => 'Soylent Green',
	  :ingredients => 'people'
    }
  ]
}
```

All fine and dandy until I had to map to values that were nested under the first level of the response:

```ruby
@response
{ 
  :sausages => [
    {
	  :name => 'Pork + Fennel'
      :ingredients => {
	    :casing => 'intestine',
	    :filling => {
	      :meat => 'pork mince',
	      :spices => 'fennel'
	    }
      }
    }
  ]
}
```

I wanted to be able to do something like this:

```ruby
fields = {
  'Name' => :sausage_name,
  'Spices' => ':ingredients[:filling[:spices]]'
}
```

So I did.

Check out the specs for how it behaves.

### Installation and usage

```ruby
gem install dive

require 'dive'
foods = { :sausages => {:pork_and_fennel => 'DELICIOUS'}}
foods[':sausages[:pork_and_fennel]']
```

Or if you become squeamish at the idea of overriding Hash's [] method:

```ruby
require 'dive/noninvasive'
foods.dive ':sausages[:pork_and_fennel]'
```

### Issues
  
* Currently only works with Ruby 1.9
* May not play well with other code that overrides core methods - my yardstick for this is enabling dive in the rspec builds and having them pass. Fails horribly at the moment

