Pod::Spec.new do |spec|
  spec.name = 'RateLimit'
  spec.version = '1.1.0'
  spec.authors = {'Sam Soffes' => 'sam@soff.es'}
  spec.homepage = 'https://github.com/soffes/RateLimit'
  spec.summary = 'Simple utility for only executing code every so often.'
  spec.source = {:git => 'https://github.com/soffes/RateLimit.git', :tag => "v#{spec.version}"}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.platform = :ios, '8.0'
  spec.frameworks = 'Foundation'
  spec.source_files = 'RateLimit/**/*.{h,m,swift}'
end
