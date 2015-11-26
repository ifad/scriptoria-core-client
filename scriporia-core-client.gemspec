Gem::Specification.new do |s|
  s.name              = 'scriptoria-core-client'
  s.version           = '0.0.1'
  s.summary           = "A Ruby client for the Scriptoria Core web service."
  s.description       = "A Ruby client for IFAD Scriptoria Core Application's REST API."

  s.author            = ["Luca Spiller", "Antonio Delfin"]
  s.email             = ["l.spiller@ifad.org", "a.delfin@ifad.org"]
  s.homepage          = "https://github.com/ifad/scriptoria-core-client"

  s.files             = `git ls-files`.split("\n")
  s.require_paths     = ["lib"]

  s.add_dependency("hawk")
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'byebug'
end
