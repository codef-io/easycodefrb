class MessageInfo
  def initialize(code, message, extra_message='')
    @code = code
    @message = message
    @extra_message = extra_message
  end

  def code()
    return @code
  end
  
  def message()
    return @message
  end

  def extra_message()
    return @extra_message
  end
end

module Message
  OK = MessageInfo.new("CF-00000", "성공")
  INVALID_JSON = MessageInfo.new("CF-00002", "json형식이 올바르지 않습니다.")
	INVALID_PARAMETER= MessageInfo.new("CF-00007", "요청 파라미터가 올바르지 않습니다.")
	UNSUPPORTED_ENCODING = MessageInfo.new("CF-00009", "지원하지 않는 형식으로 인코딩된 문자열입니다.")
	EMPTY_CLIENT_INFO = MessageInfo.new("CF-00014", "상품 요청을 위해서는 클라이언트 정보가 필요합니다. 클라이언트 아이디와 시크릿 정보를 설정하세요.")
	EMPTY_PUBLIC_KEY = MessageInfo.new("CF-00015", "상품 요청을 위해서는 퍼블릭키가 필요합니다. 퍼블릭키 정보를 설정하세요.")
	INVALID_2WAY_INFO = MessageInfo.new("CF-03003", "2WAY 요청 처리를 위한 정보가 올바르지 않습니다. 응답으로 받은 항목을 그대로 2way요청 항목에 포함해야 합니다.")
	INVALID_2WAY_KEYWORD = MessageInfo.new("CF-03004", "추가 인증(2Way)을 위한 요청은 requestCertification메서드를 사용해야 합니다.")
	BAD_REQUEST = MessageInfo.new("CF-00400", "클라이언트 요청 오류로 인해 요청을 처리 할 수 ​​없습니다.")
	UNAUTHORIZED = MessageInfo.new("CF-00401", "요청 권한이 없습니다.")
	FORBIDDEN = MessageInfo.new("CF-00403", "잘못된 요청입니다.")
	NOT_FOUND = MessageInfo.new("CF-00404", "요청하신 페이지(Resource)를 찾을 수 없습니다.")
	METHOD_NOT_ALLOWED = MessageInfo.new("CF-00405", "요청하신 방법(Method)이 잘못되었습니다.")
	LIBRARY_SERNDER_ERROR = MessageInfo.new("CF-09980", "통신 요청에 실패했습니다. 응답정보를 확인하시고 올바른 요청을 시도하세요.")
	SERVER_ERROR = MessageInfo.new("CF-09999", "서버 처리중 에러가 발생 했습니다. 관리자에게 문의하세요.")
end