

Pod::Spec.new do |s|

  s.name         = "VModel"
  s.version      = "0.0.1"
  s.summary      = "this is a simple lib for JSON to model."
  s.description  = <<-DESC
                   * This framework is a reference of others, thank you very much yan di.
                   DESC
  s.homepage     = "https://github.com/lhjzzu/VModel"
  s.license      = "MIT"
  s.author             = { "lhjzzu" => "1822657131@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/lhjzzu/VModel.git", :tag => "0.0.1" }
  s.source_files  = "sdk", "Classes/*.{h,m}"
  s.requires_arc = true
end
