require 'base64'
require 'openssl'

module EasyCodef
  module_function()
  def encode_to_file_str(file_path)
    file = File.open(file_path)
    base_64 = Base64.encode64(file.read)
    file.close()
    return base_64.encode('UTF-8').gsub(/\n/, '')
  end

  def encrypt_RSA(text, public_key)
    pub = Base64.decode64(public_key)
    key = OpenSSL::PKey::RSA.new(pub)
    enc_str = key.public_encrypt(text, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
    return Base64.encode64(enc_str).gsub(/\n/, '')
  end
end