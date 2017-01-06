Pod::Spec.new do |s|
  s.name = 'MockSix'
  s.version = '0.1.2'
  s.license = 'MIT'
  s.summary = 'An object mocking microframework for Swift'
  s.description = <<-DESC
MockSix simplifies manual object mocking in Swift by taking over some of the boilerplate
and offering an API that is hard to use incorrectly.
DESC
  s.homepage = 'https://github.com/lvsti/MockSix'
  s.social_media_url = 'https://twitter.com/cocoagrinder/'
  s.authors = { 'Tamas Lustyik' => 'elveestei@gmail.com' }
  s.source = { :git => 'https://github.com/lvsti/MockSix.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '8.4'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.2'
  s.source_files = 'MockSix/*.{swift,h}'
  s.public_header_files = 'MockSix/MockSix.h'
end

