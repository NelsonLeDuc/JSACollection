Pod::Spec.new do |s|
  s.name         = "JSACollection"
  s.version      = "1.5.0"
  s.summary      = "A framework that can parse objects from array, dictionary, & object structures."
  s.homepage     = "https://github.com/NelsonLeDuc/JSACollection"
  s.license      = 'MIT'
  s.author       = { "Nelson LeDuc" => "nelson.leduc@jumpspaceapps.com" }
  s.source       = { :git => "https://github.com/NelsonLeDuc/JSACollection.git", :tag => "#{s.version}" }
  s.source_files = "JSACollection/Classes/**/*.{h,m}"

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true
end
