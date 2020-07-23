require_relative './lib/easycodefrb.rb'

Gem::Specification.new do |s|
  s.name = 'easycodefrb'
  s.version = EasyCodef::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'COODEF Library'
  s.description = 'This library for using CODEF API'
  s.authors = ['CODEF']
  s.email = ['codef.io.dev@gmail.com']
  s.files = Dir['{lib}/**/*', 'LICENSE', 'README.md']
  s.homepage = 'https://github.com/codef-io/easycodefrb'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.0'
end
