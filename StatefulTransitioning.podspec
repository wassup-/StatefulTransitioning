Pod::Spec.new do |s|
  s.name             = 'StatefulTransitioning'
  s.version          = '0.0.1'
  s.summary          = 'iOS view controller state transitioning.'

  s.description      = <<-DESC
This library aims to provide an easy way to transitioning view controllers between different content states.
                       DESC

  s.homepage         = 'https://github.com/wassup-/StatefulTransitioning'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom Knapen' => 'tom.knapen@appwise.be' }
  s.source           = { :git => 'https://github.com/wassup-/StatefulTransitioning.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :ios, '9.0'

  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {
    'StatefulTransitioning' => ['Resources/*.xcassets', 'Resources/*.xib']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.swift_version = '4.0'
end
