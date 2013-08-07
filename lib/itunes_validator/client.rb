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
      @use_latest = (options[:use_latest] if options) || true
    end

    def validate(receipt_data)
      raise ParameterError unless receipt_data

      post_body = {}
      post_body['receipt-data'] = receipt_data
      post_body['password'] = @shared_secret if @shared_secret

      receipt_info = nil

      uri = URI(APPSTORE_VERIFY_URL_PRODUCTION)
      begin
        Net::HTTP.start(uri.host, uri.port, {use_ssl: true}) do |http|
          req = Net::HTTP::Post.new(uri.request_uri)
          req['Accept'] = 'application/json'
          req['Content-Type'] = 'application/json'
          req.body = post_body.to_json

          response = http.request(req)
          raise ItunesCommunicationError.new(response.code) unless response.code == '200'
          response_body = JSON.parse(response.body)

          case itunes_status = response_body['status'].to_i
          when 0
            receipt_info = response_body['receipt']
            if @use_latest && response_body['latest_receipt_info']
              receipt_info = response_body['latest_receipt_info']
            end
          else
            raise ItunesValidationError.new(itunes_status)
          end
        end
      rescue ItunesCommunicationError
      rescue ItunesValidationError => e
        case e.code
        when 21007
          uri = URI(APPSTORE_VERIFY_URL_SANDBOX)
          retry
        end
      end

      Receipt.from_h(receipt_info) if receipt_info
    end
  end

  class Error < StandardError
  end

  class ParameterError < Error
  end

  class ItunesCommunicationError < Error
    def initialize(code)
      @code = code
    end

    attr_reader :code
  end

  class ItunesValidationError < Error
    def initialize(code)
      @code = code
    end

    attr_reader :code
  end
end