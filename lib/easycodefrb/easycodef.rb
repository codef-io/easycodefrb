require_relative './message'
require_relative './connector'

module EasyCodef
  # AccessToken 정보
  class AccessToken
    def initialize()
      @product = ''
      @demo = ''
      @sandbox = ''
    end

    def set_token(token, service_type)
      case service_type
      when TYPE_PRODUCT
        @product = token
      when TYPE_DEMO
        @demo = token
      else
        @sandbox = token
      end
    end

    def get_token(service_type)
      return case service_type
      when TYPE_PRODUCT
        @product
      when TYPE_DEMO
        @demo
      else
        @sandbox
      end
    end
  end

  # API 요청에 필요한 정보 클래스
  # Codef 인스턴스에서 API 요청을 보낼때 서비스 타입별 필요한 정보를 가져와서 사용한다
  # 이때 정보를 저장하는 역할을 한다
  class RequestInfo
    def initialize(domain, client_id, client_secret)
      @domain = domain
      @client_id = client_id
      @client_secret = client_secret
    end

    def domain()
      return @domain
    end

    def client_id()
      return @client_id
    end

    def client_secret()
      return @client_secret
    end
  end

  # Codef 클래스
  # 요청에 필요한 설정 값들을 가지고 있으며
  # 유저의 요청 파라미터에 따라 실제 API를 요청하는 역할을 한다
  class Codef
    def initialize(public_key='')
      @access_token = AccessToken.new()
      @demo_client_id = ''
      @demo_client_secret = ''
      @client_id = ''
      @client_secret = ''
      @public_key = public_key
    end
    
    # 정식버전 클라이언트 정보 셋팅
    def set_client_info(id, secret)
      @client_id = id
      @client_secret = secret
    end

    # 데모버전 클라이언트 정보 셋팅
    def set_client_info_for_demo(id, secret)
      @demo_client_id = id
      @demo_client_secret = secret
    end

    def demo_client_id
      return @demo_client_id
    end

    def demo_client_secret
      return @demo_client_secret
    end

    def client_id
      return @client_id
    end

    def client_secret
      return @client_secret
    end

    def access_token
      return @access_token
    end

    def public_key
      return @public_key
    end

    def public_key(public_key)
      @public_key = public_key
    end

    # 서비스 타입에 해당하는 요청 정보 객체 가져오기
    def get_req_info_by_service_type(service_type)
      return case service_type
      when TYPE_PRODUCT
        RequestInfo.new(
          API_DOMAIN,
          @client_id,
          @client_secret
        )
      when TYPE_DEMO
        RequestInfo.new(
          DEMO_DOMAIN,
          @demo_client_id,
          @demo_client_secret
        )
      else
        RequestInfo.new(
          SANDBOX_DOMAIN,
          SANDBOX_CLIENT_ID,
          SANDBOX_CLIENT_SECRET
        )
      end
    end

    # API 요청
    def request_product(product_path, service_type, param)

      # 클라이언트 정보 검사
      if !has_client_info(service_type)
        res = new_response_message(Message::EMPTY_CLIENT_INFO)
        return res.to_json()
      end

      # 퍼블릭키 검사
      if @public_key == ''
        res = new_response_message(Message::EMPTY_PUBLIC_KEY)
        return res.to_json()
      end

      # 추가인증 키워드 비어있는지 체크
      if !is_empty_two_way_keyword(param)
        res = new_response_message(Message::INVALID_2WAY_KEYWORD)
        return res.to_json()
      end

      # 리퀘스트 정보 조회
      req_info = get_req_info_by_service_type(service_type)

      # 요청
      res = Connector.execute(
        product_path,
        param,
        @access_token,
        req_info,
        service_type
      )
      return res.to_json()
    end

    # 상품 추가인증 요청
    def request_certification(product_path, service_type, param)
      # 클라이언트 정보 검사
      if !has_client_info(service_type)
        res = new_response_message(Message::EMPTY_CLIENT_INFO)
        return res.to_json()
      end

      # 퍼블릭키 검사
      if @public_key == ''
        res = new_response_message(Message::EMPTY_PUBLIC_KEY)
        return res.to_json()
      end

      # 추가인증 파라미터 필수 입력 체크
      if !has_require_two_way_info(param)
        res = new_response_message(Message::INVALID_2WAY_INFO)
        return res.to_json()
      end
      
      # 리퀘스트 정보 조회
      req_info = get_req_info_by_service_type(service_type)

      # 요청
      res = Connector.execute(
        product_path,
        param,
        @access_token,
        req_info,
        service_type
      )
      return res.to_json()
    end

    # 토큰 요청
    def request_token(service_type)
      if !has_client_info(service_type)
        return nil
      end

      return case service_type
      when TYPE_PRODUCT
        Connector.request_token(CLIENT_ID, CLIENT_SECRET)
      when TYPE_DEMO
        Connector.request_token(DEMO_CLIENT_ID, DEMO_CLIENT_SECRET)
      else 
        Connector.request_token(SANDBOX_CLIENT_ID, SANDBOX_CLIENT_SECRET)
      end
    end

    # connectedID 발급을 위한 계정 등록
    def create_account(service_type, param)
      return request_product(PATH_CREATE_ACCOUNT, service_type, param)
    end

    # 계정 정보 추가
    def add_account(service_type, param)
      return request_product(PATH_ADD_ACCOUNT, service_type, param)
    end

    # 계정 정보 수정
    def update_account(service_type, param)
      return request_product(PATH_UPDATE_ACCOUNT, service_type, param)
    end

    # 계정 정보 삭제
    def delete_account(service_type, param)
      return request_product(PATH_DELETE_ACCOUNT, service_type, param)
    end

    # connectedID로 등록된 계정 목록 조회
    def get_account_list(service_type, param)
      return request_product(PATH_GET_ACCOUNT_LIST, service_type, param)
    end

    # 클라이언트 정보로 등록된 모든 connectedID 목록 조회
    def get_connected_id_list(service_type, param)
      return request_product(PATH_GET_CID_LIST, service_type, param)
    end

    private

    # 클라이언트 정보 검사
    def has_client_info(service_type)
      return case service_type
      when TYPE_PRODUCT
        @client_id.strip != '' && client_secret.strip != ''
      when TYPE_DEMO
        @demo_client_id.strip != '' && @demo_client_secret.strip != ''
      else
        SANDBOX_CLIENT_ID.strip != '' && SANDBOX_CLIENT_SECRET.strip != ''
      end
    end
  end
end

# 2Way 키워드 존재 여부 검사
def is_empty_two_way_keyword(param)
  return param['is2Way'] == nil && param['twoWayInfo'] == nil
end

# 2Way 필수 데이터 검사
def has_require_two_way_info(param)
  is2_way = param['is2Way']
  if is2_way == nil || !!is2_way != is2_way || !is2_way
    return false
  end

  two_way_info = param['twoWayInfo']
  if two_way_info == nil
    return false
  end

  return check_need_value_in_two_way_info(two_way_info)
end

# twoWayInfo 내부에 필요한 데이터가 존재하는지 검사
def check_need_value_in_two_way_info(two_way_info)
  return two_way_info['jobIndex'] != nil &&
    two_way_info['threadIndex'] != nil &&
    two_way_info['jti'] != nil &&
    two_way_info['twoWayTimestamp'] != nil
end