# Dive: for deep hash access

Dive is a gem for accessing values within nested Hashes.

Check out the specs for how it behaves.

### Installation and usage

  gem install dive

  require 'dive'
  foods {:sausages => {:pork_and_fennel => 'DELICIOUS'}}
  foods['sausages[pork_and_fennel]']

Or if you become squeamish at the idea of overriding Hash's [] method:

  require 'dive/noninvasive'
  foods.dive 'sausages[pork_and_fennel]'

Wuss.