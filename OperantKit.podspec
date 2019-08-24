Pod::Spec.new do |s|
  s.name             = "OperantKit"
  s.version          = "0.0.35"
  s.summary          = "A tool for operant conditioning"

  s.description      = <<-DESC
  OperantKit is a tool for operant conditioning experiments for Swift
                       DESC

  s.homepage         = "https://github.com/YutoMizutani/OperantKit"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Yuto Mizutani" => "yuto.mizutani.dev@gmail.com" }
  s.source           = { :git => "https://github.com/YutoMizutani/OperantKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXPENSIVE_MAN'

  s.ios.deployment_target = '12.2'
  s.osx.deployment_target = '10.14'
  s.watchos.deployment_target = '5.2'
  s.tvos.deployment_target = '12.2'

  s.requires_arc = true

  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.source_files = 'Sources/**/*.swift'
end
