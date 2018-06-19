Pod::Spec.new do |s|
  s.name             = 'StatefulTransitioning'
  s.version          = '0.1.0'
  s.summary          = 'iOS view controller state transitioning.'

  s.description      = <<-DESC
This library aims to provide an easy way to transitioning view controllers between different content states.
                       DESC

  s.homepage         = 'https://github.com/wassup-/StatefulTransitioning'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom Knapen' => 'tom.knapen@appwise.be' }
  s.source           = { :git => 'https://github.com/wassup-/StatefulTransitioning.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tom_knapen'

  s.platform = :ios, '9.0'

  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {
    'StatefulTransitioning' => ['Resources/*.xcassets', 'Resources/*.xib']
  }

  s.frameworks = 'UIKit'

  s.swift_version = '4.0'
end
