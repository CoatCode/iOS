platform :ios, '13.0'
inhibit_all_warnings!

target 'CoatCode' do
  use_frameworks!
  
  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  
  # Rx Extensions
  pod 'RxFlow'
  pod 'RxGesture'
  pod 'RxDataSources'
  
  # Networking
  pod 'Moya/RxSwift'
  
  # Tools
  pod 'R.swift'
  pod 'Reusable'
  pod 'SwiftLint'
  
  # Image
  pod 'Kingfisher'
  
  # DataBase
  pod 'RealmSwift'
  
  # Security
  pod 'KeychainAccess'
  pod 'CryptoSwift'
  
  # UI
  pod 'NVActivityIndicatorView/Extended'
  pod 'SwiftMessages'
  pod 'XLPagerTabStrip'
  pod 'KafkaRefresh'
  pod 'ImageSlideshow/Kingfisher'
  pod 'SkeletonView'
  pod 'RxTags'
  
  # Keyboard
  pod 'RxKeyboard'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
