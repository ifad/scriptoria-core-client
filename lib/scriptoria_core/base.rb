require 'active_support/concern'
require 'hawk'

module ScriptoriaCore
  class Base < Hawk::HTTP
    def initialize base, options={}
      # put any scriptoria-core stuff here
      super
    end
  end
end
