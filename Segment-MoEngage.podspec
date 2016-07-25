Pod::Spec.new do |s|
  s.name             = "Segment-MoEngage"
  s.version          = "2.0.0"
  s.summary          = "MoEngage Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.

                       This is the MoEngage integration for the iOS library.
                       DESC

  s.homepage         = "http://moengage.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "MoEngage" => "gautam@moengage.com" }
  s.source           = { :git => "https://github.com/moengage/MoEngage-Segment-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/moengage'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'Analytics', '~> 3.0'
  s.dependency 'MoEngage-iOS-SDK', '~> 1.8'
end
