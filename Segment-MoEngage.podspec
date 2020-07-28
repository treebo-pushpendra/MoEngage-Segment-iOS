Pod::Spec.new do |s|
  s.name             = "Segment-MoEngage"
  s.version          = "5.0.0"
  s.summary          = "MoEngage Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.

                       This is the MoEngage integration for the iOS library.
                       DESC

  s.homepage         = "https://moengage.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "MoEngage" => "chengappa@moengage.com" }
  s.source           = { :git => "https://github.com/moengage/MoEngage-Segment-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/moengage'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'Analytics', '~> 3.0'
  s.dependency 'MoEngage-iOS-SDK', '>=6.1', '< 7.0'
  end
