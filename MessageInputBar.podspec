Pod::Spec.new do |s|

   # 1 - Specs
   s.platform = :ios
   s.name = 'MessageInputBar'
   s.summary = 'A powerful InputAccessoryView ideal for messaging applications.'
   s.source = { :git => 'https://github.com/MessageKit/MessageInputBar.git', :tag => s.version }
   s.homepage = 'https://github.com/MessageKit/MessageInputBar'
   s.requires_arc = true

   # 2 - Version
   s.version = '0.1.0'
   s.pod_target_xcconfig = {
      "SWIFT_VERSION" => "4.0",
   }
   s.ios.deployment_target = '9.0'

   # 3 - License
   s.license = { :type => "MIT", :file => "LICENSE.md" }

   # 4 - Author
   s.social_media_url = 'https://twitter.com/nathantannar4'
   s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

   # 5 - Source Files
   s.source_files = 'Sources/**/*.swift'

end
