
Pod::Spec.new do |s|
  s.name         = "RNAdmobMediation"
  s.version      = "1.0.0"
  s.summary      = "Package to run Admob mediation inside a React Native Project"
  s.description  = <<-DESC
                  RNAdmobMediation
                   DESC
  s.homepage     = "https://esound.app"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "marco@spicysparks.ocm" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/marf/react-native-admob-mediation.git", :tag => "master" }
  s.source_files  = "*.{h,m}"
  s.requires_arc = true
  s.static_framework = true

  s.dependency "React"
  s.dependency 'Google-Mobile-Ads-SDK'
  s.dependency 'GoogleMobileAdsMediationAppLovin'
  s.dependency 'GoogleMobileAdsMediationVungle'
  s.dependency 'GoogleMobileAdsMediationUnity'
  s.dependency 'GoogleMobileAdsMediationMoPub'
  s.dependency 'GoogleMobileAdsMediationFacebook'
  s.dependency 'GoogleMobileAdsMediationTapjoy'

  #s.dependency "others"

end
