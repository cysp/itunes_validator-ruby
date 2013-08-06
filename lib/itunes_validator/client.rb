require 'json'
require 'net/https'
require 'uri'

module ItunesValidator
  APPSTORE_VERIFY_URL_PRODUCTION = 'https://buy.itunes.apple.com/verifyReceipt'
  APPSTORE_VERIFY_URL_SANDBOX = 'https://sandbox.itunes.apple.com/verifyReceipt'

  def self.validate(options=nil, receipt_data)
    v = Client.new(options)
    v.validate(receipt_data)
  end

  class Client
    def initialize(options=nil)
      @shared_secret = options[:shared_secret] if options
    end

    def validate(receipt_data)
      raise ParameterError unless receipt_data

      post_body = {}
      post_body['receipt-data'] = receipt_data
      post_body['password'] = @shared_secret if @shared_secret

      receipt = false

      uri = URI(APPSTORE_VERIFY_URL_PRODUCTION)
      begin
        Net::HTTP.start(uri.host, uri.port, {use_ssl: true}) do |http|
          req = Net::HTTP::Post.new(uri.request_uri)
          req['Accept'] = 'application/json'
          req['Content-Type'] = 'application/json'
          req.body = post_body.to_json

          response = http.request(req)
          response_body = JSON.parse(response.body)

          case itunes_status = response_body['status'].to_i
          when 0
            receipt = response_body['receipt']
          else
            raise ItunesValidationError.new(itunes_status)
          end
        end
      rescue ItunesValidationError => e
        case e.code
        when 21007
          uri = URI(APPSTORE_VERIFY_URL_SANDBOX)
          retry
        end
      end

      receipt
    end
  end

  class Error < StandardError
  end

  class ParameterError < Error
  end

  class ItunesValidationError < Error
    def initialize(code)
      @code = code
    end

    attr_reader :code
  end
end
