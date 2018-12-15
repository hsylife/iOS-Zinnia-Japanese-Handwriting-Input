Pod::Spec.new do |s|
s.name         = "Zinnia_iOS"
s.version      = "1.0"
s.summary      = "Handwriting recognition for Japanese Kanji / Kana in iOS"
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = "https://github.com/hsylife/iOS-Zinnia-Japanese-Handwriting-Input"
s.author       = { Yuta Hoshino =>  <ythshn@gmail.com> }
s.source       = { :git => "https://github.com/hsylife/iOS-Zinnia-Japanese-Handwriting-Input.git", :tag => "#{s.version}" }
s.platform     = :ios, "8.0"
s.requires_arc = true
s.source_files = 'iOS-Zinnia-Japanese-Handwriting-Input/**/*.{h,m,cpp}'
s.resources    = 'iOS-Zinnia-Japanese-Handwriting-Input/**/*.{xib,png,plist,model}'
end
