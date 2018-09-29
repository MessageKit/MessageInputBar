Pod::Spec.new do |s|

    # 1 - Specs
    s.platform = :ios
    s.name = 'MessageInputBar'
    s.summary = 'A powerful InputAccessoryView ideal for messaging applications.'
    s.homepage = 'https://github.com/MessageKit/MessageInputBar'
    s.requires_arc = true

    # 2 - Version
    s.version = '0.4.0'
    s.pod_target_xcconfig = {
      "SWIFT_VERSION" => "4.2",
    }
    s.ios.deployment_target = '9.0'
    s.source = { :git => 'https://github.com/MessageKit/MessageInputBar.git', :tag => s.version }

    # 3 - License
    s.license = { :type => "MIT", :file => "LICENSE.md" }

    # 4 - Author
    s.social_media_url = 'https://twitter.com/nathantannar4'
    s.author = { "Nathan Tannar" => "nathantannar4@gmail.com" }

    # 5 - Source Files
    s.default_subspecs = 'Core'

    s.subspec 'Core' do |ss|
        ss.source_files = 'Sources/**/*.swift'
    end

    s.subspec 'AttachmentManager' do |b|
        b.source_files = "Plugins/AttachmentManager/**/*.swift"
        b.dependency 'MessageInputBar/Core'
    end

    s.subspec 'AutocompleteManager' do |c|
        c.source_files = "Plugins/AutocompleteManager/**/*.swift"
        c.dependency 'MessageInputBar/Core'
    end

end
