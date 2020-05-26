# 메시지 정보로 결과 생성
# MessageInfo 인스턴스를 받아서 메시지 정보로 해시를 만든다
def new_response_message(message_info)
  return {
    'result'=>{
      'code'=>message_info.code,
      'message'=>message_info.message,
      'extra_message'=>message_info.extra_message,
    },
    'data'=>{}
  }
end