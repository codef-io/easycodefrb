require_relative './message'
require_relative './connector'

module EasyCodef
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

  class Codef
    def initialize()
      @access_token = ''
      @demo_client_id = ''
      @demo_client_secret = ''
      @client_id = ''
      @client_secret = ''
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

    def access_token
      return @access_token
    end

    def access_token=(access_token)
      @access_token = access_token
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
    def request_api(product_path, service_type, param)
      valid_flag = true

      valid_flag = check_client_info(service_type)
      # 클라이언트 정보 검사
      if !valid_flag
        res = new_response_message(Message::EMPTY_CLIENT_INFO)
        return res.to_json()
      end

      # 추가인증 키워드 체크
      valid_flag = check_two_way_keyword(param)
      if !valid_flag
        res = new_response_message(Message::INVALID_2WAY_KEYWORD)
        return res.to_json()
      end

      # 리퀘스트 정보 조회
      req_info = get_req_info_by_service_type(service_type)

      # 요청
      res = execute(product_path, param, self, req_info)
      return res.to_json()
    end

    private

    # 클라이언트 정보 검사
    def check_client_info(service_type)
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
def check_two_way_keyword(param)
  return param['is2Way'] == nil && param['twoWayInfo'] == nil
end
