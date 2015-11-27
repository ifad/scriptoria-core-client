require 'active_support/concern'
require 'hawk'

module ScriptoriaCore
  class Base < Hawk::HTTP
    def initialize base, options={}
      # put any scriptoria-core stuff here
      super
    end

    def request(method, path, options = {})
      url = build_url(path)

      timeout = { connecttimeout: 2, timeout: 2 }
      options = timeout.merge(options).merge(:method => method)
      if options[:params] && method == :get # To deal with array parameters
        options[:params] = options[:params].to_param
      end

      request = Typhoeus::Request.new(url, options)
      request.on_complete(&method(:response_handler))
      request.run.response_body
    end
  end
end
