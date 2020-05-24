module EasyCodef
  class Response
    def initialize(result, data={})
      @result = result
      @data = data
    end

    def result()
      return @result
    end

    def data()
      return @data
    end
  end
end

def new_response_message(message_info)
  result = {
    'code'=>message_info.code,
    'message'=>message_info.message,
    'extra_message'=>message_info.extra_message,
  }
  return EasyCodef::Response.new(result)
end