$:.push File.expand_path("../lib", __FILE__)
require 'scriptoria_core/client/version'

Gem::Specification.new do |s|
  s.name              = 'scriptoria-core-client'
  s.version           = ScriptoriaCore::Client::VERSION
  s.summary           = "A Ruby client for the Scriptoria Core web service."
  s.description       = "A Ruby client for IFAD Scriptoria Core Application's REST API."
  s.license           = "MIT"

  s.author            = ["Luca Spiller", "Antonio Delfin"]
  s.email             = ["l.spiller@ifad.org", "a.delfin@ifad.org"]
  s.homepage          = "https://github.com/ifad/scriptoria-core-client"

  s.files             = `git ls-files`.split("\n")
  s.require_paths     = ["lib"]

  s.add_dependency('hawk', '~> 0')

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec', '>= 3.4.0'

  s.test_files = s.files.grep %r[^(test|spec|features)]
end
