#
#  Be sure to run `pod spec lint CWCrashProtect.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "CWCrashProtect"
  spec.version      = "0.0.2"
  spec.summary      = "CWCrashProtect 线上崩溃保护库"

  
  spec.description  = <<-DESC
  avoid common OC crash
                   DESC

  spec.homepage     = "https://github.com/ChengwenY/CrashProtect.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license  = 'MIT'
  spec.author       = { "ChengwenY" => "yuanchegnwen@gmail.com" }
  
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/ChengwenY/CrashProtect.git", :tag => "#{spec.version}" }
  
  spec.source_files = 'CWCrashProtect/CWCrashProtect.h'
#  spec.source_files  = "CWCrashProtect/**/*.h", "CWCrashProtect/**/*.m"
  spec.subspec 'Base' do |a|
    a.source_files = 'CWCrashProtect/Base/*.{h,m}'
  end

  spec.subspec 'ContainerProtect' do |a|
    a.source_files = 'CWCrashProtect/ContainerProtect/*.{h,m}'
    a.dependency 'CWCrashProtect/Base'
  end

  spec.subspec 'KVOProtect' do |a|
    a.source_files = 'CWCrashProtect/KVOProtect/*.{h,m}'
    a.dependency 'CWCrashProtect/Base'
  end

  spec.subspec 'SelectorProtect' do |a|
    a.source_files = 'CWCrashProtect/SelectorProtect/*.{h,m}'
    a.dependency 'CWCrashProtect/Base'
  end


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
