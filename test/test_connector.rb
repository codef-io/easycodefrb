require 'json'
require 'minitest/autorun'
require 'easycodef/connector'
require 'easycodef/util'
require 'easycodef/message'

def create_param_for_create_connected_id()
	publicKey = "MIIBIjANBgkqhkiG9w0BAQ" +
		"EFAAOCAQ8AMIIBCgKCAQEAuhRrVDeMf" +
		"b2fBaf8WmtGcQ23Cie+qDQqnkKG9eZV" +
		"yJdEvP1rLca+0CUOuAnpE8yGPY3HEbd" +
		"xKTsbIxxV9H8DCEMntXq2VP4loQoYUl" +
		"0h9dTjtBVWvhYev0s7N5B8Qu9LtykE2" +
		"k9KBuSZ+5dXulnHYdYjBaifZL6pzoD1" +
		"ckXoa4TtIuPjZZGXzr3Ivt5LDxPoPfw" +
		"1qMdqWRF9/YQSK1jZYa7PNR1Hbd8KB8" +
		"85VEcXNRU7ADHSgdYRBYB8apsPwaChy" +
		"jgrV98ATLOD7Dl4RlPtXcx/vEKjVMdt" +
		"CqJ2IHKeJoUCzBPY59U/mtIhjPuQmwS" +
		"MLEnLisDWEZMkenO0xJbwOwIDAQAB"

	password = EasyCodef.encrypt_RSA("password", publicKey)
	m = {
		"countryCode":  "KR",
		"businessType": "BK",
		"clientType":   "P",
		"organization": "0004",
		"loginType":    "1",
		"id":           "testID",
		"password":     password,
	}

	accountList = [m]
	param = {
		"accountList": accountList,
	}
	return param
end

class ConnectorTest < Minitest::Test

  # 토큰 요청 테스트
  def test_request_token()
    m = Connector.request_token(EasyCodef::SANDBOX_CLIENT_ID, EasyCodef::SANDBOX_CLIENT_SECRET)
    assert m != nil
    assert '' != m[EasyCodef::KEY_ACCESS_TOKEN] && nil != m[EasyCodef::KEY_ACCESS_TOKEN]
    assert m[EasyCodef::KEY_ACCESS_TOKEN].instance_of? String
  end

  # 토큰 셋팅
  def test_set_token()
    codef = EasyCodef::Codef.new()
    Connector.set_token(EasyCodef::SANDBOX_CLIENT_ID, EasyCodef::SANDBOX_CLIENT_SECRET, codef)
    
    assert codef.access_token != nil && codef.access_token != ''
  end

  # request_product 메소드 테스트
  def test_request_product()
    data = create_param_for_create_connected_id().to_json()

    access_token = ''
    res = Connector.request_product(EasyCodef::SANDBOX_DOMAIN + '/failPath', access_token, data)
    assert_equal(Message::NOT_FOUND.code, res['result']['code'])

    # 정상 프로세스
    codef = EasyCodef::Codef.new()
    Connector.set_token(EasyCodef::SANDBOX_CLIENT_ID, EasyCodef::SANDBOX_CLIENT_SECRET, codef)
    res = Connector.request_product(EasyCodef::SANDBOX_DOMAIN + EasyCodef::PATH_CREATE_ACCOUNT, codef.access_token, data)

    assert res != nil
    # result = JSON.parse(res)
    assert res['data']['connectedId'] != nil && res['data']['connectedId'] != ''
  end

  # execute 테스트
  def test_execute()
    codef = EasyCodef::Codef.new()

    body = create_param_for_create_connected_id()
    req_info = codef.get_req_info_by_service_type(EasyCodef::TYPE_SANDBOX)
    res = Connector.execute(EasyCodef::PATH_CREATE_ACCOUNT, body, codef, req_info)
    assert res != nil
    assert res['data']['connectedId'] != nil
  end
end