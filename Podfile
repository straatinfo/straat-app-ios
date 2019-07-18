# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Straat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Straat
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage', '~> 3.5'
  pod 'iOSDropDown'

  # Pods for GoogleMapiOS
  source 'https://github.com/CocoaPods/Specs.git'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  
  # Pod for Kingfisher (imageloader)
  pod 'Kingfisher', '~> 5.0'
  
  # Pod for Keyboard Manager
  pod 'IQKeyboardManagerSwift'

  # Pod for UItextview Placeholder (testing)
  pod 'UITextView+Placeholder'
  
  pod 'Socket.IO-Client-Swift'
  
  pod 'SwiftyJSON', '~> 4.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
      end
  end
end
