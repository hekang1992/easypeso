# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'EasePeso' do
  use_frameworks!
  
  pod 'AAILiveness', :http => 'https://prod-guardian-cv.oss-ap-southeast-5.aliyuncs.com/sdk/iOS-liveness-detection/2.0.8/iOS-Liveness-SDK-V2.0.8.tar.bz2' , type: :tbz
  pod 'AAINetwork', :http => 'https://prod-guardian-cv.oss-ap-southeast-5.aliyuncs.com/sdk/iOS-libraries/AAINetwork/AAINetwork-V1.0.2.tar.bz2', type: :tbz
  
  pod 'OpenCombine', '~> 0.14.0'
  pod 'OpenCombineDispatch', '~> 0.14.0'
  pod 'OpenCombineFoundation', '~> 0.14.0'
  pod 'RxCocoa'
  pod 'NSObject+Rx'
  pod 'KeychainAccess'
  pod 'AppsFlyerFramework'
  
  pod 'Kingfisher'
  pod 'Alamofire'
  pod 'Then'
  pod 'HandyJSON', :git => 'https://github.com/Miles-Matheson/HandyJSON.git'

  pod 'DeviceKit'
  pod 'SnapKit'
  pod 'IQKeyboardManagerSwift'
  pod 'MBProgressHUD'
  pod 'MarqueeLabel'
  pod 'BRPickerView'
  pod 'TYCyclePagerView'
  pod 'MJRefresh'
  
#  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "12.0"
      end
    end
  end

end
