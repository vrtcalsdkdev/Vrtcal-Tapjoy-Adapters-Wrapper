Pod::Spec.new do |s|
    s.name         = "Vrtcal-Tapjoy-Adapters-Wrapper"
    s.version      = "1.0.0"
    s.summary      = "Wrapper for Vrtcal-AppLovin-Adapters"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2020 Vrtcal Markets, Inc.
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scott.mccoy@vrtcal.com" }
    
    s.source       = { :git => "https://github.com/vrtcalsdkdev/Vrtcal-Tapjoy-Adapters-Wrapper.git", :tag => "#{s.version}" }
    s.source_files = "*.swift"

    s.platform = :ios
    s.ios.deployment_target  = '12.0'

    s.dependency 'Vrtcal-Adapters-Wrapper-Parent'
    s.dependency 'Vrtcal-Tapjoy-Adapters'

    s.static_framework = true
end
