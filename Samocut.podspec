Pod::Spec.new do |s|
  s.name = 'Samocat'
  s.version = ‘1.0.0’
  s.license = 'MIT'
  s.summary = "Youtube video information parser"
  s.homepage = 'https://github.com/OrangesoftLLC/Samocat'
  s.authors = { ‘Orangesoft LLC’ => 'http://www.orangesoft.co' }
  s.source = { :git => 'https://github.com/OrangesoftLLC/Samocat.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Source/*.swift'
end

