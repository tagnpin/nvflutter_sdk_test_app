#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_notifyvisitors.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_notifyvisitors'
  s.version          = '1.4.0'
  s.summary          = 'NotifyVisitors Flutter SDK for marketing automation software that designed to help marketers take their campaigns to the next level.'
  s.description      = 'NotifyVisitors sdk to attribute and analyse user behaviour analytics like funnel, cohort, RFM also used to increase Mobile App engagement through push notification, in-app nudges.'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.homepage         = 'http://www.notifyvisitors.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Neeraj Sharma' => 'neeraj.s@notifyvisitors.com' }
  s.source           = { :path => '.' }

  s.ios.deployment_target = '12.0'
  s.static_framework = true
  s.dependency 'notifyvisitors', '7.3.2'
  s.dependency 'notifyvisitorsNudges', '0.0.1'
  s.public_header_files = 'Classes/**/*.h'

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.swift_version = '5.0'
  
end
