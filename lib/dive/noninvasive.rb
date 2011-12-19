require 'dive/dive'
Hash.send :include, Dive::Read
Hash.send :include, Dive::Write