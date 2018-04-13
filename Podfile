source 'http://github.intra.douban.com/mirror/Specs.git'
source 'http://github.intra.douban.com/iOS/CocoaPodsSpecs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Test1' do
  pod 'OpenCV'
  pod 'DOUFoundation',             :git => 'https://github.intra.douban.com/iOS/DOUFoundation.git', :commit => 'a40451618d35fe59087eafbb04a5f1a62a8df29f'
  pod 'Polymorph',                 :git => 'https://github.com/bigyelow/Polymorph.git', :commit => 'f4ff2e538f183658f8b74503df6011ff2fb7bfab'
  pod 'DoubanObjCClient',       :git => 'https://github.intra.douban.com/iOS/DoubanObjCClient.git', :commit => 'd267df399045d8b2bf2b64c7d5bcd8c4d1cbe8c0'
  # pod 'FRDFangorn/CommonBusiness/Common', :git => 'https://github.intra.douban.com/iOS/FRDFangorn.git', :commit => '5b2f497352ab50a7e19cebb5c0ced822eca17ca7'
  # pod 'FRDSearch',                 :git => 'https://github.intra.douban.com/iOS/FRDSearch.git', :commit => 'ea862103bb2e2d0b0dc12d076b998bf6f19ba4f9'
end

post_install do | installer |
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
