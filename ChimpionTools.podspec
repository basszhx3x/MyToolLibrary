Pod::Spec.new do |s|
  s.name             = 'ChimpionTools'
  s.version          = '1.2.9'
  s.summary          = 'A collection of useful Swift tools and utilities.'
  s.description      = <<-DESC
MyToolLibrary is a collection of useful Swift tools, utilities, and extensions that can help speed up iOS development.
                       DESC

  s.homepage         = 'https://github.com/basszhx3x/MyToolLibrary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'basszhx3x' => 'basszhx3x@gmail.com' }
  s.source           = { :git => 'https://github.com/basszhx3x/MyToolLibrary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/MyToolLibrary/**/*'
  
  s.ios.resource_bundle = { 'ChimpionTools' => [
      'Sources/Assets/**/*',
      "Sources/MyToolLibrary/Resources/*"
    ]
  }
#  s.resources = [
#  #      "Resources/Images/**/*.{png,jpg}",  # 所有图片资源
#  #      "Resources/Views/**/*.xib",         # 所有 XIB 资源
#         "Sources/MyToolLibrary/**/*.json"            # 单个配置文件
#  ]
  s.frameworks = 'Foundation', 'UIKit', 'CoreImage'
  
    # 资源文件
  #s.resource_bundles = {
  #  'MyLibrary' => ['Resources/*.png', 'Resources/*.xib']
  #}

  # 公开的头文件（如果是 Swift，通常不需要）
  # s.public_header_files = 'Sources/**/*.h'

  # 依赖其他库
  # s.dependency 'Alamofire', '~> 5.4'
  s.dependency 'KeychainSwift'
  s.dependency 'SmartCodable'
  s.dependency 'SnapKit'
  s.dependency 'Kingfisher'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyUserDefaults'
  s.dependency 'SwiftyJSON'
  s.dependency 'MJRefresh'
  s.dependency 'SwipeCellKit'
  s.dependency 'Localize-Swift'
  s.dependency 'SwiftDate'
  s.dependency 'MCToast'
#  s.dependency 'MCBubble', :path => './'
#  s.dependency 'MCToast', :path => './'
  
end
