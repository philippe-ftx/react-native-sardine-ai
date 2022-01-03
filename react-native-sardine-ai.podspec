# react-native-sardine-ai.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-sardine-ai"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-sardine-ai
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-sardine-ai"
  # brief license entry:
  s.license      = "commercial"
  # optional - use expanded license entry instead:
  s.license    = { :type => "commercial", :file => "LICENSE" }
  s.authors      = { "Your Name" => "yourname@email.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-sardine-ai.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.vendored_frameworks = "ios/Frameworks/MobileIntelligence.xcframework"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end

