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
  end
end