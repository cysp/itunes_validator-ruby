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

  def test_validation_noproxy_client
    proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
    return if proxy

    receipt_data=ENV['RECEIPT_DATA']
    return unless receipt_data

    v = ItunesValidator::Client.new()
    r = v.validate(receipt_data)
    assert_not_nil(r)
  end

  def test_validation_noproxy_convenience
    proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
    return if proxy

    receipt_data=ENV['RECEIPT_DATA']
    return unless receipt_data

    r = ItunesValidator.validate(receipt_data)
    assert_not_nil(r)
  end

  def test_validation_proxy_client
    proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
    return unless proxy

    proxy_host, proxy_port = proxy.split(':')
    assert_not_nil(proxy_host)

    receipt_data=ENV['RECEIPT_DATA']
    return unless receipt_data

    v = ItunesValidator::Client.new({proxy_host: proxy_host, proxy_port: proxy_port})
    r = v.validate(receipt_data)
    assert_not_nil(r)
  end

  def test_validation_proxy_convenience
    proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy'] || ENV['HTTP_PROXY'] || ENV['http_proxy']
    return unless proxy

    proxy_host, proxy_port = proxy.split(':')
    assert_not_nil(proxy_host)

    receipt_data=ENV['RECEIPT_DATA']
    return unless receipt_data

    r = ItunesValidator.validate({proxy_host: proxy_host, proxy_port: proxy_port}, receipt_data)
    assert_not_nil(r)
  end

  def test_invalid_parameters_missing_options
    assert_raises(ArgumentError) do
      ItunesValidator.validate
    end
  end

  def test_invalid_parameters_nil_options
    assert_raises(ItunesValidator::ParameterError) do
      ItunesValidator.validate(nil)
    end
  end

  def test_invalid_parameters_no_receipt
    assert_raises(ItunesValidator::ParameterError) do
      ItunesValidator.validate({shared_secret: 'secret'}, nil)
    end
  end
end
