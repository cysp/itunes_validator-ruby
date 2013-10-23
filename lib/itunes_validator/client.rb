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
      @return_latest_too = (options[:return_latest_too] if options) || true
      @proxy = [options[:proxy_host], options[:proxy_port] || 8080] if (options && options[:proxy_host])
    end

    def validate(receipt_data)
      raise ParameterError unless receipt_data

      post_body = {}
      post_body['receipt-data'] = receipt_data
      post_body['password'] = @shared_secret if @shared_secret

      receipt_info = latest_receipt_info = nil

      uri = URI(APPSTORE_VERIFY_URL_PRODUCTION)
      begin
        h = Net::HTTP::Proxy(*@proxy) if @proxy
        h = Net::HTTP unless h
        h.start(uri.host, uri.port, {use_ssl: true}) do |http|
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
            latest_receipt_info = response_body['latest_receipt_info']
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

      receipts = [receipt_info, latest_receipt_info].map{ |ri| Receipt.from_h(ri) if ri }

      if @use_latest
        return receipts.compact.last
      end

      if @return_latest_too
        return receipts
      end

      receipts[0]
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
