#
# Be sure to run `pod lib lint DataTransferLayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DataTransferLayer'
  s.version          = '1.0.0'
  s.summary          = 'Data Transfer layer for API written in swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This is a library that helps you manage data.
    It allows you to store, retrieve, and process data efficiently.
    The goal of this library is to simplify data handling tasks in iOS applications.
                       DESC

  s.homepage         = 'https://github.com/gopi453/DataTransferLayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gopi Kothapati' => 'gopi19453@gmail.com' }
  s.source           = { :git => 'https://github.com/gopi453/DataTransferLayer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'DataTransferLayer/Classes/**/*.swift'
  s.pod_target_xcconfig = { 'CODE_SIGN_IDENTITY' => 'iPhone Developer' }
  s.swift_versions = ['4.0']


  # s.resource_bundles = {
  #   'DataTransferLayer' => ['DataTransferLayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
