PROJECT = 'RateLimit.xcodeproj'
SCHEME = 'RateLimit-macOS'

desc 'Run the tests'
task :test do
  require_binary 'xcodebuild', 'brew install xcodebuild'
  require_binary 'xcpretty', 'bundle install'
  sh "xcodebuild test -project #{PROJECT} -scheme #{SCHEME} -destination 'platform=OS X,arch=x86_64' | bundle exec xcpretty --color; exit ${PIPESTATUS[0]}"
end

task :default => :test


private

def require_binary(binary, install)
  if `which #{binary}`.length == 0
    fail "\nERROR: #{binary} isn't installed. Please install #{binary} with the following command:\n\n    $ #{install}\n\n"
  end
end
