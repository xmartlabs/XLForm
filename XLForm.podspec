Pod::Spec.new do |s|
  s.name     = 'XLForm'
  s.version  = '3.1.1'
  s.license  = { :type => 'MIT' }
  s.summary  = 'XLForm is the most flexible and powerful iOS library to create dynamic table-view forms.'
  s.description = <<-DESC
                    The goal of the library is to get the same power of hand-made forms but spending 1/10 of the time. XLForm provides a very powerful DSL used to create a form, validate & serialize the form data. It keeps track of this specification on runtime, updating the UI on the fly.
                  DESC
  s.homepage = 'https://gitlab.6minutecanoe.com/ios-pods/PPRXLForm'
  s.authors  = { 'Martin Barreto' => 'martin@xmartlabs.com' }
  s.source   = { :git => 'https://gitlab.6minutecanoe.com/ios-pods/PPRXLForm.git', :tag => s.version }
  s.source_files = 'XLForm/XL/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.ios.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.resource = 'XLForm/XLForm.bundle'
end
