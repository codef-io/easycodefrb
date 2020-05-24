require 'minitest/autorun'
require 'easycodef/properties'

class PropertiesTest < Minitest::Test
  # 코드에프 반환 테스트 이미
  def test_get_codef_domain()
    assert_equal(
      get_codef_domain(EasyCodef::TYPE_PRODUCT),
      EasyCodef::API_DOMAIN
    )
    assert_equal(
      get_codef_domain(EasyCodef::TYPE_DEMO),
      EasyCodef::DEMO_DOMAIN
    )
    assert_equal(
      get_codef_domain(EasyCodef::TYPE_SANDBOX),
      EasyCodef::SANDBOX_DOMAIN
    )
  end
end