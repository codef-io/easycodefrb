require 'minitest/autorun'
require 'json'
require 'easycodef'
require 'easycodef/message'
require_relative './test_connector'

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

  # 클라이언트 정보 셋팅 검사 테스트
  def test_check_client_info()
    codef = EasyCodef::Codef.new()

    flag = codef.send(:check_client_info, EasyCodef::TYPE_SANDBOX)
    assert flag == true
    flag = codef.send(:check_client_info, EasyCodef::TYPE_PRODUCT)
    assert flag == false
    flag = codef.send(:check_client_info, EasyCodef::TYPE_DEMO)
    assert flag == false

    codef.set_client_info('real', 'secret')
    codef.set_client_info_for_demo('demo', 'demo_secret')
    flag = codef.send(:check_client_info, EasyCodef::TYPE_PRODUCT)
    assert flag == true
    flag = codef.send(:check_client_info, EasyCodef::TYPE_DEMO)
    assert flag == true
  end

  # request_product 테스트
  def test_request_api()
    # 클라이언트 정보 체크
    codef = EasyCodef::Codef.new()
    param = create_param_for_create_connected_id()
    res = codef.request_api(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_PRODUCT,
      param
    )
    res = JSON.parse(res)
    assert res['result']['code'] == Message::EMPTY_CLIENT_INFO.code

    # 2way 키워드 존재여부 검사
    param_2way = {
      'is2Way'=>true
    }
    res = codef.request_api(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_SANDBOX,
      param_2way
    )
    res = JSON.parse(res)
    assert res['result']['code'] == Message::INVALID_2WAY_KEYWORD.code

    # 결과 테스트
    res = codef.request_api(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_SANDBOX,
      param
    )
    res = JSON.parse(res)
    assert res['data']['connectedId'] != nil
  end

  # 2way 키워드 체크 테스트
  def test_check_two_way_keyword()
    param = {}
    flage = check_two_way_keyword(param)
    assert flage == true

    param['is2Way'] = true
    flage = check_two_way_keyword(param)
    assert flage == false

    param['twoWayInfo'] = {}
    flage = check_two_way_keyword(param)
    assert flage == false
  end
end