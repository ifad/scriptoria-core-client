require 'pathname'
require 'active_support/inflector'
require 'scriptoria_core/client/version'

module ScriptoriaCore
  autoload :Base,     'scriptoria_core/base.rb'

  module Client
    extend self

    def self.configure base, options={}
      @@client = Base.new(base, options)
      self
    end

    # Ping the ScriptoriaCore API
    # Raises Hawk::Error if the request fails
    # @return nil
    def self.ping
      response = client.get('/v1/ping')
      unless response['ping'] == 'pong'
        raise PingError, "Unexpected response #{response.inspect}"
      end
    end

    def self.start!(workflow, callbacks_or_callback, fields = {})
      request_body = { workflow: workflow }

      if callbacks_or_callback.is_a?(String)
        request_body[:callback] = callbacks_or_callback
      else
        request_body[:callbacks] = callbacks_or_callback
      end

      request_body[:fields] = fields

      client.post('/v1/workflows', body: request_body)['id']
    end

    def self.cancel!(workflow_id)
      client.post("/v1/workflows/#{workflow_id}/cancel")
    end

    def self.proceed!(url, fields)
      client.post(url, body: { fields: fields })
    end

    class PingError < Hawk::Error; end

    private

    def self.client
      @@client
    end
  end
end
