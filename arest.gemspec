Gem::Specification.new do |s|
  s.name          = 'arest'
  s.version       = '0.9.1.1'
  s.date          = '2015-06-12'
  s.summary       = "A REST client"
  s.description   = "A Very Simple REST client"
  s.authors       = ["Tomek Gryszkiewicz"]
  s.email         = "grych@tg.pl"
  s.files         = ["lib/arest.rb"]
  s.test_files    = ["spec/arest_spec.rb", "spec/spec_helper.rb"]
  s.homepage      = "https://github.com/grych/arest"
  s.license       = "MIT"
  s.add_runtime_dependency "json", '~> 1.8', '>= 1.8.3'
  s.add_runtime_dependency "activesupport", '~> 4.2', '>= 4.2.1'
  s.add_development_dependency "rspec", '~> 3.2', '>= 3.2.0'
  s.add_development_dependency "bundler", "~> 1.8"
end
