include FileUtils::Verbose

namespace :test do
  desc "Run the XLForm Tests"
  task :ios do
    run_tests('XLForm Tests', 'iphonesimulator10.2')
    tests_failed unless $?.success?
  end
end

task :test do
  Rake::Task['test:ios'].invoke
end

task :default => 'test'

private

def run_tests(scheme, sdk)
  sh("xcodebuild -workspace 'Tests/XLForm Tests.xcworkspace' -scheme '#{scheme}' -sdk '#{sdk}' -destination 'OS=10.1,name=iPhone 7' -configuration Release clean test | xcpretty -c ; exit ${PIPESTATUS[0]}") rescue nil
end

def tests_failed
  puts red("Unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end
