Pod::Spec.new do |s|
s.name         = 'MTCameraKit'
s.version      = '0.0.1'
s.author       = { 'alexis' => 'shuifengxu@gmail.com' }
s.homepage     = 'https://github.com/alexsicn/'
s.summary      = 'CameraKit'
s.license      = { :type => 'MIT'}
s.source       = { :path => 'DevelopmentPods/MTCameraKit'}
s.requires_arc = true

s.ios.deployment_target = '11.0'

s.prefix_header_file = false
s.source_files = '*.{swift}'


end
