require 'net/http'
require 'uri'
require 'json'
require 'base64'

require_relative './response'
require_relative './message'

# 상품 요청
module Connector
  module_function()
  def request_product(req_url, token, body_str)
    uri = URI.parse(req_url)
    header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    }

    if token != '' && token != nil
      header['Authorization'] = 'Bearer ' + token
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri, header)
    req.body = body_str

    res = http.request(req)

    return case res
    when Net::HTTPOK
      data = URI.decode(res.body)
      return JSON.parse(data)
    when Net::HTTPBadRequest
      new_response_message(Message::BAD_REQUEST)
    when Net::HTTPUnauthorized
      new_response_message(Message::UNAUTHORIZED)
    when Net::HTTPForbidden
      new_response_message(Message::FORBIDDEN)
    when Net::HTTPNotFound
      new_response_message(Message::NOT_FOUND)
    else
      new_response_message(Message::SERVER_ERROR)
    end
  end

  # 엑세스 토큰 요청
  def request_token(client_id, client_secret)
    uri = URI.parse(EasyCodef::OAUTH_DOMAIN + EasyCodef::PATH_GET_TOKEN)

    auth = client_id + ':' + client_secret
    enc_auth = Base64.encode64(auth).gsub(/\n/, '')

    header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ' + enc_auth
    } 

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri, header)
    req.body = 'grant_type=client_credentials&scope=read'
    
    res = http.request(req)

    return case res
    when Net::HTTPOK
      JSON.parse(res.body)
    else
      return nil
    end
  end

  # 토큰 셋팅
  # Codef 인스턴스 변수에 조회된 access_token을 셋팅한다
  def set_token(client_id, client_secret, codef)
    repeat_cnt = 3
    i = 0
    if codef.access_token == ''
      while i < repeat_cnt
        token_map = request_token(client_id, client_secret)
        if token_map != nil
          access_token = token_map[EasyCodef::KEY_ACCESS_TOKEN]
          codef.access_token = access_token
          if access_token != nil && access_token != ''
            break
          end
        end

        sleep(0.020)
        i += 1
      end
    end
  end

  # 실행
  def execute(url_path, body, codef, req_info)
    set_token(req_info.client_id, req_info.client_secret, codef)
    enc_body = URI.decode(body.to_json())
    res = request_product(req_info.domain + url_path, codef.access_token, enc_body)
    return res
  end
end