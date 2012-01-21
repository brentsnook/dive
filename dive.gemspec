# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dive/version"

Gem::Specification.new do |s|
  s.name        = "dive"
  s.version     = Dive::VERSION
  s.authors     = ["Brent Snook"]
  s.email       = ["brent@fuglylogic.com"]
  s.homepage    = "http://github.com/brentsnook/dive"
  s.summary     = %q{For deep hash access. Read and write values within nested hashes.}
  s.description = %q{For accessing values within nested Hashes. For example: {:sausages => {:pork_and_fennel => 'DELICIOUS'}}[':sausages[:pork_and_fennel]']}

  s.rubyforge_project = "dive"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.7"
end
