require 'scriptoria_core/client/version'

module ScriptoriaCore
  autoload :Errors, 'scriptoria_core/errors.rb'
  autoload :Http,   'scriptoria_core/http.rb'

  module Client
    include Http

    extend self

    # Ping the ScriptoriaCore API
    # Raises ScriptoriaCore::Errors::Client::UnexpectedResponseError if the request fails
    # @return nil
    def ping
      response = get('/v1/ping')
      check_response_status!(response, 200)

      unless response_json(response)['ping'] == 'pong'
        raise ScriptoriaCore::Errors::UnexpectedResponseError, "Unexpected response #{response.inspect}"
      end
    end

    def start!(workflow, callbacks_or_callback, fields = {})
      request_body = { workflow: workflow }

      if callbacks_or_callback.is_a?(String)
        request_body[:callback] = callbacks_or_callback
      else
        request_body[:callbacks] = callbacks_or_callback
      end

      request_body[:fields] = fields

      response = post('/v1/workflows', request_body)
      check_response_status!(response, 201)
      response_json(response)['id']
    end

    def cancel!(workflow_id)
      response = post("/v1/workflows/#{workflow_id}/cancel")
      check_response_status!(response, 201)
    end

    def proceed!(url, fields)
      response = post(url, { fields: fields })
      check_response_status!(response, 201)
    end

    private

    def check_response_status!(response, status)
      unless response.response_code == status
        raise ScriptoriaCore::Errors::UnexpectedResponseError.new("Expected status #{status} for: #{response.inspect}")
      end
    end

    def response_json(response)
      JSON.parse(response.body)
    rescue Exception => e
      raise ScriptoriaCore::Errors::UnexpectedResponseError.new("JSON parse error: #{e.message} for: #{response.inspect}")
    end
  end
end
