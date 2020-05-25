require 'minitest/autorun'
require 'easycodef'

class EasyCodefTest < Minitest::Test

  # 서비스 타입별 요청정보 조회 테스트
  def test_get_req_info_by_service_type()
    codef = EasyCodef::Codef.new()
    codef.set_client_info('real_client_id', 'real_client_secret')
    codef.set_client_info_for_demo('demo_client_id', 'demo_client_secret')
    req_info = codef.get_req_info_by_service_type(EasyCodef::TYPE_PRODUCT)
    assert req_info.domain == EasyCodef::API_DOMAIN
    assert req_info.client_id == 'real_client_id'
    assert req_info.client_secret == 'real_client_secret'

    req_info = codef.get_req_info_by_service_type(EasyCodef::TYPE_DEMO)
    assert req_info.domain == EasyCodef::DEMO_DOMAIN
    assert req_info.client_id == 'demo_client_id'
    assert req_info.client_secret == 'demo_client_secret'

    req_info = codef.get_req_info_by_service_type(EasyCodef::TYPE_SANDBOX)
    assert req_info.domain == EasyCodef::SANDBOX_DOMAIN
    assert req_info.client_id == EasyCodef::SANDBOX_CLIENT_ID
    assert req_info.client_secret == EasyCodef::SANDBOX_CLIENT_SECRET
  end
end