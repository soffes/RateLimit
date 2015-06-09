PROJECT = 'RateLimit.xcodeproj'
SCHEME = 'RateLimit-iOS'

desc 'Run the tests'
task :test do
  require_binary 'xcodebuild', 'brew install xcodebuild'
  require_binary 'xcpretty', 'bundle install'
  sh "xcodebuild test -project #{PROJECT} -scheme #{SCHEME} -destination 'platform=iOS Simulator,name=iPhone 4s,OS=latest' | bundle exec xcpretty --color; exit ${PIPESTATUS[0]}"
end

task :default => :test

desc 'Print test coverage of the last test run.'
task :coverage do
  require_binary 'slather', 'bundle install'
  sh 'slather coverage -s'
end


private

def require_binary(binary, install)
  if `which #{binary}`.length == 0
    fail "\nERROR: #{binary} isn't installed. Please install #{binary} with the following command:\n\n    $ #{install}\n\n"
  end
end
