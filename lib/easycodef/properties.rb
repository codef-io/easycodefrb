module EasyCodef
  OAUTH_DOMAIN = "https://oauth.codef.io" # OAUTH 서버 도메인
  PATH_GET_TOKEN = "/oauth/token" # OAUTH 엑세스 토큰 발급 URL PATH
  SANDBOX_DOMAIN = "https://sandbox.codef.io" # 샌드박스 서버 도메인
  SANDBOX_CLIENT_ID = "ef27cfaa-10c1-4470-adac-60ba476273f9" # 샌드박스 엑세스 토큰 발급을 위한 클라이언트 아이디
  SANDBOX_CLIENT_SECRET = "83160c33-9045-4915-86d8-809473cdf5c3" # 샌드박스 액세스 토큰 발급을 위한 클라이언트 시크릿
  DEMO_DOMAIN = "https://development.codef.io" # 데모 서버 도메인
  API_DOMAIN = "https://api.codef.io" # 정식 서버 도메인

  PATH_CREATE_ACCOUNT = "/v1/account/create" # 계정 등록 URL
  PATH_ADD_ACCOUNT = "/v1/account/add" # 계정 추가 URL
  PATH_UPDATE_ACCOUNT = "/v1/account/update" # 계정 수정 URL
  PATH_DELETE_ACCOUNT = "/v1/account/delete" # 계정 삭제 URL
  PATH_GET_ACCOUNT_LIST = "/v1/account/list" # 계정 목록 조회 URL
  PATH_GET_CID_LIST = "/v1/account/connectedId-list" # 커넥티드 아이디 목록 조회 URL

  KEY_RESULT = "result" # 응답부 수행 결과 키워드
  KEY_CODE = "code" # 응답부 수행 결과 메시지 코드 키워드
  KEY_MESSAGE = "message" # 응답부 수행 결과 메시지 키워드
  KEY_EXTRA_MESSAGE = "extraMessage" # 응답부 수행 결과 추가 메시지 키워드
  KEY_DATA = "data"
  KEY_ACCOUNT_LIST = "accountList" # 계정 목록 키워드
  KEY_CONNECTED_ID = "connectedId"
  KEY_ACCESS_TOKEN = 'access_token'

  KEY_INVALID_TOKEN = "invalidToken" # 엑세스 토큰 거절 사유1
  KEY_ACCESS_DENIEND = "accessDenied" # 엑세스 토큰 거절 사유2

  TYPE_PRODUCT = 0
  TYPE_DEMO = 1
  TYPE_SANDBOX = 2
end


# 서비스 타입에 해당하는 코드에프 도메인 반환
def get_codef_domain(service_type)
  return case service_type
  when EasyCodef::TYPE_PRODUCT
    EasyCodef::API_DOMAIN
  when EasyCodef::TYPE_DEMO
    EasyCodef::DEMO_DOMAIN
  else
    EasyCodef::SANDBOX_DOMAIN
  end
end