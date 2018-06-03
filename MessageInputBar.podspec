Pod::Spec.new do |s|
   s.name = 'MessageInputBar'
   s.version = '0.1.0'
   s.license = { :type => "MIT", :file => "LICENSE.md" }

   s.summary = 'A powerful InputAccessoryView ideal for messaging applications.'
   s.homepage = 'https://github.com/MessageKit/MessageInputBar'
   s.social_media_url = 'https://twitter.com/nathantannar4'
   s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

   s.source = { :git => 'https://github.com/MessageKit/MessageInputBar.git', :tag => s.version }
   s.source_files = 'Sources/**/*.swift'

   s.pod_target_xcconfig = {
      "SWIFT_VERSION" => "4.0",
   }

   s.ios.deployment_target = '9.0'

   s.requires_arc = true
end
