require 'base64'
require 'openssl'

module EasyCodef
  module_function()

  # 파일을 base64 인코딩한다
  # 파일 경로를 인자로 받는다
  def encode_to_file_str(file_path)
    file = File.open(file_path)
    base_64 = Base64.encode64(file.read)
    file.close()
    return base_64.encode('UTF-8').gsub(/\n/, '')
  end

  # RSA 암호화한다
  # 암호화할 정보와 퍼블릭키를 인자로 받는다
  def encrypt_RSA(text, public_key)
    pub = Base64.decode64(public_key)
    key = OpenSSL::PKey::RSA.new(pub)
    enc_str = key.public_encrypt(text)
    return Base64.encode64(enc_str).gsub(/\n/, '')
  end
end