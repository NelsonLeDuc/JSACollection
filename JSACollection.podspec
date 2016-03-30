Pod::Spec.new do |s|
  s.name              = "JSACollection"
  s.version           = "1.6.2"
  s.summary           = "A framework that can parse objects from array, dictionary, & object structures."
  s.homepage          = "https://github.com/NelsonLeDuc/JSACollection"
  s.license           = 'MIT'
  s.author            = { "Nelson LeDuc" => "nelson.leduc@jumpspaceapps.com" }
  s.source            = { :git => "https://github.com/NelsonLeDuc/JSACollection.git", :tag => "#{s.version}" }
  s.default_subspec   = "Core"

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.subspec 'Core' do |sc|
    sc.source_files = "JSACollection/Classes/**/*.{h,m}"
    sc.exclude_files = "JSACollection/Classes/Public/Swift/**"
  end

  s.subspec 'Swift' do |sw|
    sw.ios.deployment_target = '8.0'
    sw.source_files = "JSACollection/Classes/Public/Swift/**"
    sw.dependency 'JSACollection/Core'
  end
end
