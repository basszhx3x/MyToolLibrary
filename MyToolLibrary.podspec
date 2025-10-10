Pod::Spec.new do |s|
  s.name             = 'MyToolLibrary'
  s.version          = '1.0.0'
  s.summary          = 'A collection of useful Swift tools and utilities.'
  s.description      = <<-DESC
MyToolLibrary is a collection of useful Swift tools, utilities, and extensions that can help speed up iOS development.
                       DESC

  s.homepage         = 'https://github.com/basszhx3x/MyToolLibrary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'basszhx3x' => 'basszhx3x@gmail.com' }
  s.source           = { :git => 'https://github.com/basszhx3x/MyToolLibrary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/MyToolLibrary/**/*.swift'
  
  s.frameworks = 'Foundation', 'UIKit'
  
    # 资源文件
  #s.resource_bundles = {
  #  'MyLibrary' => ['Resources/*.png', 'Resources/*.xib']
  #}

  # 公开的头文件（如果是 Swift，通常不需要）
  # s.public_header_files = 'Sources/**/*.h'

  # 依赖其他库
  # s.dependency 'Alamofire', '~> 5.4'
  s.dependency 'KeychainSwift'
  
end
