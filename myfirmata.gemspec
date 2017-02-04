Gem::Specification.new do |s|
  s.name = 'myfirmata'
  s.version = '0.1.0'
  s.summary = 'The MyFirmata gem uses the ArduinoFirmata gem to trigger messages and listen for actionable messages using the SimplePubSub messaging system'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myfirmata.rb']
  s.add_runtime_dependency('sps-sub', '~> 0.3', '>=0.3.3')
  s.add_runtime_dependency('arduino_firmata', '~> 0.3', '>=0.3.7')  
  s.signing_key = '../privatekeys/myfirmata.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/myfirmata'
end
