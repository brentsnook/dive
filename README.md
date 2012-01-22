# Dive: for deep hash access

Dive is a gem for accessing values within nested Hashes.

## Why?

Well, it all started when I was mapping human readable names taken from a Cucumber table to fields in a JSON response:

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

Dive has been tested with ruby 1.9.2 and 1.8.7.

## Installation and usage

```ruby
gem install dive

require 'dive'
foods = { :sausages => {:pork_and_fennel => 'DELICIOUS'}}
foods[':sausages[:pork_and_fennel]']
foods[':sausages[:coles_bbq]'] = 'YUCK'
```

Or if you become squeamish at the idea of overriding Hash's [] method:

```ruby
require 'dive/noninvasive'
foods.dive ':sausages[:pork_and_fennel]'
foods.dive_store ':sausages[:coles_bbq]', 'YUCK'
```

## A Note on Dive Keys

Anything containing square brackets can be parsed as a Dive key, for example 
```ruby
'first[second]'
```
If you are experiencing strange behaviour while using dive to override Hash methods, please check that none of your keys are unintentionally being recognised as such. A test case for the unusual ones would be much appreciated.