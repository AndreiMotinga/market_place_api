module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  # TODO: #1 remove when done with headers
  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.marketplace.v#{version}"
    end

    # def api_response_format(format = Mime::JSON)
    #   request.headers['Accept'] = "#{request.headers['Accept']}, #{format}"
    #   request.headers['Content-Type'] = format.to_s
    # end

    def include_default_accept_headers
      api_header
      # api_response_format
    end
  end
end

RSpec.configure do |config|
  config.include Request::JsonHelpers, type: :controller

  # TODO: #1 remove
  config.include Request::HeadersHelpers, type: :controller
  config.before(:each, type: :controller) do
    include_default_accept_headers
  end
end
