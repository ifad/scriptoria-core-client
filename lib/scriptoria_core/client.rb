require 'pathname'
require 'active_support/inflector'

module ScriptoriaCore
  autoload :Base,     'scriptoria_core/base.rb'

  module Client
    extend self

    def self.configure base, options={}
      @@client = Base.new(base, options)
      self
    end

    def self.client
      @@client
    end

    def self.start!(workflow, callbacks_or_callback)
      request_body = { workflow: workflow }

      if callbacks_or_callback.is_a?(String)
        request_body[:callback] = callbacks_or_callback
      else
        request_body[:callbacks] = callbacks_or_callback
      end

      client.post('/v1/workflows', body: request_body)['id']
    end

    def self.proceed!(url, fields)
      client.post(url, body: { fields: fields })
    end
  end
end
