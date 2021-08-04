source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.0'

use_frameworks!

target "Tote" do
  pod 'Nuke', '~> 10.3'
  pod 'KeychainAccess', '~> 4.2'
  pod 'CocoaLumberjack/Swift', '~> 3.7'
  pod 'SwiftLint', '~> 0.42.0'
  pod 'SwiftFormat/CLI', '~> 0.48'
  pod 'ReachabilitySwift', '~> 5.0.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end