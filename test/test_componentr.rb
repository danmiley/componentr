require 'test/unit'
require 'componentr'

class ComponentrTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal "hello world", Componentr.hi("english")
  end

  def test_any_hello
    assert_equal "hello world", Componentr.hi("ruby")
  end

  def test_spanish_hello
    assert_equal "hola mundo", Componentr.hi("spanish")
  end
end
