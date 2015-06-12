Gem::Specification.new do |s|
  s.name          = 'arest'
  s.version       = '0.9.1.0'
  s.date          = '2015-06-12'
  s.summary       = "A REST client"
  s.description   = "A Very Simple REST client"
  s.authors       = ["Tomek Gryszkiewicz"]
  s.email         = "grych@tg.pl"
  s.files         = ["lib/arest.rb"]
  s.test_files    = ["spec/arest_spec.rb", "spec/spec_helper.rb"]
  s.homepage      = "https://github.com/grych/arest"
  s.license       = "MIT"
  s.add_runtime_dependency "json", ">= 1.8.3"
  s.add_runtime_dependency "activesupport", ">= 3.2.13"
  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
end
