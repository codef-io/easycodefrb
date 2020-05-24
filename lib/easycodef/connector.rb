require 'net/http'
require 'uri'
require 'json'
require 'base64'

require_relative './response'
require_relative './message'

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
    return data
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
    # TODO: 에러 처리
    return nil
  end
end

def set_token(client_id, client_secret, codef)
  repeat_cnt = 3
  i = 0
  if codef.access_token == ''
    while i < repeat_cnt
      token_map = request_token(client_id, client_secret)
      access_token = token_map[EasyCodef::KEY_ACCESS_TOKEN]
      codef.access_token = access_token
      if access_token != nil && access_token != ''
        break
      end

      sleep(0.020)
      i += 1
    end
  end
end