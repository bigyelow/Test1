source 'http://github.intra.douban.com/mirror/Specs.git'
source 'http://github.intra.douban.com/iOS/CocoaPodsSpecs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Test1' do
  pod 'OpenCV'
  pod 'DOUFoundation',             :git => 'https://github.intra.douban.com/iOS/DOUFoundation.git', :commit => 'a40451618d35fe59087eafbb04a5f1a62a8df29f'
  pod 'Polymorph',                 :git => 'https://github.com/douban/Polymorph.git', :commit => 'ec503cfe3fcf9e18f8c675175273d5cde608d1e2'
  pod 'DoubanObjCClient',          :git => 'https://github.intra.douban.com/iOS/DoubanObjCClient.git', :commit => 'bfdad53f7442bd91a34548ee1f2af0f7715e45e0'
  pod 'FRDNetwork',                :git => 'https://github.intra.douban.com/huangduyu/FRDNetwork', :commit => '2963b19d755f3b2a709986bca90caa41f7db6f04'
  # pod 'FRDFangorn/CommonBusiness/Common', :git => 'https://github.intra.douban.com/iOS/FRDFangorn.git', :commit => '5b2f497352ab50a7e19cebb5c0ced822eca17ca7'
  pod 'Rexxar',                    :git => 'https://github.com/douban/rexxar-ios.git', :commit => '4c30548545cb4c4912f6bf7fd2d2438ea60b775d'
  pod 'MTURLProtocol',              :git => 'https://github.intra.douban.com/iOS/MTURLProtocol', :commit => 'e3ebed6fb6d53dc74994a1c875b449ac95e97364'
end

post_install do | installer |
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
