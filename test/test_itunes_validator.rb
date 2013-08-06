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
