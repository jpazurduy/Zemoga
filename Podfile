# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Zemoga' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Zemoga
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'SwiftyBeaver'

  target 'ZemogaTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      if config.name == 'Dev-Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
        config.build_settings['OTHER_SWIFT_FLAGS'] << '-DDEV -DDEBUG'
      end
    end
  end
end
