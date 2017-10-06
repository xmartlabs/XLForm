Pod::Spec.new do |s|
  s.name     = 'XLForm-extension-PhotoView'
  s.version  = '3.3.0'
  s.license  = { :type => 'MIT' }
  s.summary  = '在XLForm的基础上增加了自定义Cell类型，此Cell封装了TZImagePicker项目，以适配XLForm'
  s.description = <<-DESC
  TZImagePicker:https://github.com/banchichen/TZImagePickerController
  XLForm:https://github.com/xmartlabs/XLForm
                  DESC
  s.homepage = 'https://github.com/qd-hzc/XLForm-extension-PhotoView'
  s.authors  = { '尹彬' => 'ybkk1027@gmail.com' }
  s.source   = { :git => 'https://github.com/qd-hzc/XLForm-extension-PhotoView.git', :tag => s.version }
  s.source_files = 'XLForm/XL/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.ios.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.resource = 'XLForm/XLForm.bundle'
end
