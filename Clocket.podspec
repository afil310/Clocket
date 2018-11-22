Pod::Spec.new do |s|
    s.name             = 'Clocket'
    s.version          = '1.0.1'
    s.summary          = 'Customizable analog clock framework for iOS written in Swift'
    s.homepage         = 'https://github.com/afil310/Clocket'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andrey Filonov' => 'andrey.filonov@gmail.com' }
    s.source           = { :git => 'https://github.com/afil310/Clocket.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/afil310'
    s.ios.deployment_target = '11.0'
    s.swift_version    = '4.2'
    s.source_files     = 'Clocket/Classes/**/*'
    s.frameworks       = 'UIKit', 'AVFoundation'
end
