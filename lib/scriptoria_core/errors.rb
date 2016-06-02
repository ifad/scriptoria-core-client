module ScriptoriaCore
  module Errors
    class Error                   < StandardError; end
    class HttpError               < Error;         end
    class UnexpectedResponseError < Error;         end
  end
end
