require 'uri'
require 'typhoeus'

module ScriptoriaCore
  module Http
    extend self

    def configure(base_uri, config = {})
      @@base_uri = base_uri
      @@config   = {
        connectiontimeout: 2,
        timeout:           2
      }.merge(config)
      self
    end

    protected

    def get(url)
      request(:get, url)
    end

    def post(url, body = nil)
      request(:post, url, body: body)
    end

    def request(method, path, options = {})
      url = url_for(path)

      timeout = { connecttimeout: @@config[:connectiontimeout], timeout: @@config[:timeout]}
      options = timeout.merge(options).merge({
        method:     method,
        headers: {
          "User-Agent" => "ScriptoriaCore::Client #{ScriptoriaCore::Client::VERSION}"
        }
      })

      request = Typhoeus::Request.new(url, options)
      request.on_complete do |response|
        if response.success?
          #No-op
        elsif response.timed_out?
          raise ScriptoriaCore::Errors::HttpError.new("Request timed out after #{options[:timeout]} seconds")
        else
          raise ScriptoriaCore::Errors::HttpError.new("HTTP Request failed: #{response.code} - #{response.return_message}")
        end
      end

      request.run
    end

    def url_for(path)
      if path =~ /http/
        path
      else
        URI.join(@@base_uri, path)
      end
    end
  end
end
