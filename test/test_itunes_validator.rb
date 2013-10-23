# vim : et sw=2

require 'test/unit'

require 'itunes_validator'

class TestItunesValidator < Test::Unit::TestCase
  def test_instantiation
    v = ItunesValidator::Client.new
    assert_not_nil(v)

    v = ItunesValidator::Client.new({foo: 'bar'})
    assert_not_nil(v)

    v = ItunesValidator::Client.new({shared_secret: 'secret'})
    assert_not_nil(v)

    v = ItunesValidator::Client.new({proxy_host: '127.0.0.1', proxy_port: 8888})
    assert_not_nil(v)
  end

  def test_validation
    receipt_data=ENV['RECEIPT_DATA']
    return unless receipt_data

    v = ItunesValidator::Client.new()
    r = v.validate(receipt_data)
    assert_not_nil(r)

    proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
    if proxy
      proxy_host, proxy_port = proxy.split(':')
      assert_not_nil(proxy_host)

      v = ItunesValidator::Client.new({proxy_host: proxy_host, proxy_port: proxy_port})
      r = v.validate(receipt_data)
      assert_not_nil(r)

      r = ItunesValidator.validate({proxy_host: proxy_host, proxy_port: proxy_port}, receipt_data)
      assert_not_nil(r)
    end
  end

  def test_invalid_parameters
    assert_raises(ArgumentError) do
      ItunesValidator.validate
    end

    assert_raises(ItunesValidator::ParameterError) do
      ItunesValidator.validate(nil)
    end

    assert_raises(ItunesValidator::ParameterError) do
      ItunesValidator.validate({shared_secret: 'secret'}, nil)
    end
  end
end
