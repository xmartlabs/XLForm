XLFormPhotoView
---------------


![Screenshot of photo Example](Examples/photo.gif)

 
 
CocoaPods方式安装
--------------------------
1. Add the following line in the project's Podfile file:
`pod 'XLFormPhotoView', '~> 3.3.0'`.
2. Run the command `pod install` from the Podfile folder directory.


建议安装方式
--------------------------
1. 检出源码
2. 运行例子，查看效果
3. 复制代码到你的xcode项目，参照“代码位置”
4. info.plist中设置图片访问权限
```
 <key>NSCameraUsageDescription</key>
	<string>访问相机以拍照</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>允许定位以把位置保存到照片中</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>访问相册以选择照片</string>
```



代码位置
--------------------------

1. 检出代码后，xcode运行可在Custom Row里看到效果，例子在：https://github.com/qd-hzc/XLFormPhotoView/tree/master/Examples/Objective-C/Examples/CustomRows/TZImagePicker

2. 使用方法在：https://github.com/qd-hzc/XLFormPhotoView/blob/master/Examples/Objective-C/Examples/CustomRows/CustomRowsViewController.m



传送门
--------------------------
1. [TZImagePicker](https://github.com/banchichen/TZImagePickerController) 
2. [XLForm](https://github.com/xmartlabs/XLForm)

