source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
    end
  end
end

target 'OpenWeather' do
    pod 'Alamofire'
		pod 'Kingfisher'
end
