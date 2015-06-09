Pod::Spec.new do |s|
  s.name = 'RateLimit'
  s.version = '1.0.0'
  s.authors = {'Sam Soffes' => 'sam@soff.es'}
  s.homepage = 'https://github.com/soffes/RateLimit'
  s.summary = 'Simple utility for only executing code every so often.'
  s.source = {:git => 'https://github.com/soffes/RateLimit.git', :tag => "v#{s.version}"}
  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.frameworks = 'Foundation'
  s.source_files = 'RateLimit/**/*.{h,m,swift}'
end
