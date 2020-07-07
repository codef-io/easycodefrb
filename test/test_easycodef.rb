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
  def test_has_client_info()
    codef = EasyCodef::Codef.new()

    flag = codef.send(:has_client_info, EasyCodef::TYPE_SANDBOX)
    assert flag == true
    flag = codef.send(:has_client_info, EasyCodef::TYPE_PRODUCT)
    assert flag == false
    flag = codef.send(:has_client_info, EasyCodef::TYPE_DEMO)
    assert flag == false

    codef.set_client_info('real', 'secret')
    codef.set_client_info_for_demo('demo', 'demo_secret')
    flag = codef.send(:has_client_info, EasyCodef::TYPE_PRODUCT)
    assert flag == true
    flag = codef.send(:has_client_info, EasyCodef::TYPE_DEMO)
    assert flag == true
  end

  # 2way 키워드 체크 테스트
  def test_is_empty_two_way_keyword()
    param = {}
    flag = is_empty_two_way_keyword(param)
    assert flag == true

    param['is2Way'] = true
    flag = is_empty_two_way_keyword(param)
    assert flag == false

    param['twoWayInfo'] = {}
    flag = is_empty_two_way_keyword(param)
    assert flag == false
  end

  # 2Way 필수 데이터 체크 테스트
  def test_has_require_two_way_info()
    # is2Way 실패 케이스
    param = {}
    flag = has_require_two_way_info(param)
    assert flag == false

    param = { 'is2Way'=>'hi' }
    flag = has_require_two_way_info(param)
    assert flag == false

    param = { 'is2Way'=>false }
    flag = has_require_two_way_info(param)
    assert flag == false

    # twoWayInfo 실패케이스
    param = {
      'is2Way'=>true,
      'twoWayInfo'=>nil
    }
    flag = has_require_two_way_info(param)
    assert flag == false

    # 성공 케이스
    param['twoWayInfo'] = {
      'jobIndex'=>'1',
      'threadIndex'=>'1',
      'jti'=>'1',
      'twoWayTimestamp'=>'1'
    }
    flag = has_require_two_way_info(param)
    assert flag == true

  end

  # twoWayInfo 내부검사 테스트
  def test_check_need_value_in_two_way_info()
    two_way_info = {
      'jobIndex'=>'1'
    }
    flag = check_need_value_in_two_way_info(two_way_info)
    assert flag == false

    two_way_info['threadIndex'] = '1'
    flag = check_need_value_in_two_way_info(two_way_info)
    assert flag == false

    two_way_info['jti'] = '1'
    flag = check_need_value_in_two_way_info(two_way_info)
    assert flag == false

    two_way_info['twoWayTimestamp'] = '1'
    flag = check_need_value_in_two_way_info(two_way_info)
    assert flag == true
  end

  # request_product 테스트
  def test_request_product()
    # 클라이언트 정보 체크
    codef = EasyCodef::Codef.new()
    param = create_param_for_create_connected_id()
    res = codef.request_product(
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
    res = codef.request_product(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_SANDBOX,
      param_2way
    )
    res = JSON.parse(res)
    assert res['result']['code'] == Message::INVALID_2WAY_KEYWORD.code

    # 결과 테스트
    res = codef.request_product(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_SANDBOX,
      param
    )
    res = JSON.parse(res)
    assert res['data']['connectedId'] != nil
  end

  # certification 요청 테스트
  def test_request_certification()
    codef = EasyCodef::Codef.new()
    param = create_param_for_create_connected_id()
    param['is2Way'] = true
    param['twoWayInfo'] = nil

    res = codef.request_certification(
      EasyCodef::PATH_CREATE_ACCOUNT,
      EasyCodef::TYPE_SANDBOX,
      param
    )
    res = JSON.parse(res)
    assert res['result']['code'] == Message::INVALID_2WAY_INFO.code
  end

  # 토큰 요청 테스트
  def test_request_token()
    codef = EasyCodef::Codef.new()
    res = codef.request_token(EasyCodef::TYPE_SANDBOX)
    assert res['access_token'] != nil

    # 클라이언트 정보가 없을 경우 nil
    res = codef.request_token(EasyCodef::TYPE_PRODUCT)
    assert res == nil

  end
end