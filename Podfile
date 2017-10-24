# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'InnoCV' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for InnoCV
  pod 'RealmSwift'
  #pod 'Kingfisher', '~> 3.0'
  pod 'Alamofire'
  pod 'SwiftyJSON', :git => 'https://github.com/appsailor/SwiftyJSON', :branch => 'swift3'
  #pod 'Fabric'
  #pod 'Crashlytics'
  pod 'IQKeyboardManager'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end