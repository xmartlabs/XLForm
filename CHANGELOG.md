# Change Log
All notable changes to this project will be documented in this file.

### Version 3.3.0:
* Added `cellConfigForSelector` to style XLFormOptionsViewController
* Added properties to **limit number of characters** in `XLFormTextFieldCell` and `XLFormTextViewCell`
* Minor fixes

### Version 3.2.0:
* Added XL_APP_EXTENSIONS macro to allow app extensions (@MuscleRumble #357)
* Added shouldChangeTextInRange delegate call for UITextView. (@kiancheong #782)
* Added support for NSFormatter (@ziogaschr, @fwhenin, @bhirt-bpl #306)
* Added `height` property to XLFormRowDescriptor to allow setting height of individual cells.

### Version 3.1.2:
* Update row in `cellForRowAtIndexPath` instead of `willDisplayCell`
* Added cancel action to image selector (by koenpunt)
* Other minor fixes

### Version 3.1.1
* Allow setting width percentage on UITextView
* Added custom inline row example
* Fixed bug where XLFormImageCell was not added to project
* Add ability to `end editing` on scroll
* Other bugs and refactor

### Version 3.1.0
* Added Carthage support
* Added NSCoding protocol
* Allowed HTTP connections
* Several bugfixes and improvements.

### Version 3.0.2
* Fix issue when inline pickers expand beyond table.

### Version 3.0.1

* Improvements and bug fixes.
* Ability to left, right align textfields. Ability to set up a minimum textField width.
* If form is being shown, assigning a new form automatically reload the tableview.
* Update objective-c and swift example projects.
* Swift compatibility fixes.
* Long email validation added.
* Fixed row copy issue, now valueTransformer value is copied.
* Fixed step counter row layout issues.
* Fixed issue "Last form field hides beneath enabled navigation controller's toolbar".
* Fixed issue "Navigating between cells using bottom navigation buttons causes table cell dividers to disappear".
* Use UIAlertController instead UIActionSheet/UIAlertView if possible.
* Hidden and disabled rows resign first responder before changing state.
* onChangeBlock added to rowDescriptor.
* use tintColor as default button row color.
* By default accessoryView is no longer shown for inline rows.
* Fix NSBundle issues to use XLForm as dynamic framework.

### Version 3.0.0

* `hidden`, `disable` properties added to `XLFormRowDescriptor`. `@YES` `@NO` or a `NSPredicate` can be used to hide, disable de row.
* `hidden` property added to `XLFormSectionDescriptor`. `@YES` `@NO` or a `NSPredicate` can be used to hide the section.
* Added `XLFormRowDescriptorTypeCountDownTimerInline` and `XLFormRowDescriptorTypeCountDownTimer` row type with an example.
* Deleted `dateFormatter` property and added support to use the `NSValueTransformer` to convert the selected object to a NSString in the XLFormDateCell class.

* Added `XLFormRowDescriptorTypeCountDownTimerInline` and `XLFormRowDescriptorTypeCountDownTimer` row type with an example.
* Deleted `dateFormatter` property and added support to use the `NSValueTransformer` to convert the selected object to a NSString in the XLFormDateCell class.


### Version 2.2.0

* Fixed "(null)" caption when `XLFormRowDescriptorTypeSelectorLeftRight` row required error message is shown.
* Refresh the cell content instead of recreating one, when the form get back from a selection.
* Added XLFormRowDescriptor to validations error to easily show an error mask.
* Use row tag in validation error message if row does not have a title. It is also possible to set up a custom message if needed
* Added a convenience method to add a XLFormRowDescriptor instance before another one.
* Allow nil values in cellConfig and cellConfigAtConfigure.
* Fix constraints for textFieldCell when it is configured to be right aligned.
* Add asterisk to required segmentedCells if needed.
* Fail validation for empty strings and NSNull on required rows.
* Segue support added to buttons and selectors.
* Ability to configure a storyboardId or a viewController nibName to by used by button and selector rows as presented view controller.
* Fix scrolling to top when status bar is tapped.
* Fix wrong type of XLFormRowDescriptorTypeDecimal row. Now it's converted to NSNumber.
* Fix issue: XLFormRegexValidator only checks regex validation for NSStrings, not working for number.
* Callconfigure method from awakeFromNib on XLFormBaseCell.
* Assign form.delegate from inside setForm: method.
* Added custom cell, validation, reordering, can insert, can delete examples.
* Added support for inputAccessoryView. Default input accessory view allows to navigate among rows. Fully optionally and customizable.
* Added suport for row navigation. Fully optionally and customizable.
* beginEditing: endEditing: methods added. These method are called each time a row gains / loses firstResponder. They bring the ability to do UI changes.
* Read Only mode added. `disable` property added to XLFormDescriptor class.
* Rename `label` XLFormTextViewCell property as `textLabel`.
* fix position of multivalued section accessory view.
* Can delete, can delete, can reorder section mode added. it's possible to enable some of them, don't need to enable all modes.

### Version 2.1.0

* Change `XLFormRowDescriptorTypeText`, `XLFormRowDescriptorTypeName` and `XLFormRowDescriptorTypeTextView` keyboard type to `UIKeyboardTypeDefault`.
* Added `XLFormRowDescriptorTypeInfo` row type and example.
* Added `XLFormRowDescriptorTypeSelectorPopover` row type and example.
* CI added. Created Test project into Tests folder and set up Travis.
* Documented how to customize UI. Added an example.
* Now XLFormViewController extends from UIViewController instead of UITableViewController.
* Added tableView property as a XLFormViewController IBOutlet.
* Added support for storyboard reuse identifier and nib file.
* Button selection can be handled using a selector or block.
* Added addAsteriskToRequiredRowsTitle property to XLFormDescriptor. NO is used as value by default.
* Image cell has been removed because it depends on AFNetworking and now needs to be implemented as a custom cell. You can find the image custom cell in Examples/Others/CustomCells.

### Version 2.0.0

* Added `XLFormRowDescriptorTypeMultipleSelector` row type and example.
* Added `XLFormRowDescriptorTypeSelectorPickerView` row type and example.
* Added `XLFormRowDescriptorTypeSelectorPickerViewInline` row type and example.
* Added generic way to create inline selector rows.
* Ability to customize row animations.
* `(NSDictionary *)formValues;` XLFormViewController method added in order to get raw form data.
* Added `XLFormRowDescriptorTypeSelectorSegmentedControl` row type and example.
* AFNetworking dependency removed.
* Added `XLFormRowDescriptorTypeStepCounter` row type and related example.


### Version 1.0.1

* Added storyboard example.
* Added button `XLFormRowDescriptorTypeButton` example.
* Documented how to add a custom row.
* Fixed issues: [#2](https://github.com/xmartlabs/XLForm/issues/2 "#2"), [#3](https://github.com/xmartlabs/XLForm/issues/3 "#3"), [#27](https://github.com/xmartlabs/XLForm/issues/27 "#27"), [#38](https://github.com/xmartlabs/XLForm/issues/38 "#38").
* Fixed crash caused by inline date rows. [#6](https://github.com/xmartlabs/XLForm/issues/6 "#6")
* Fixed ipad issue *invalid cell layout*. [#10](https://github.com/xmartlabs/XLForm/issues/10 "#10")
* New convenience methods to insert sections dinamically. [#13](https://github.com/xmartlabs/XLForm/pull/13 "#13")
* Change default label style to `UIFontTextStyleBody`. [#18](https://github.com/xmartlabs/XLForm/issues/18 "#18")
* Added step counter row, `XLFormRowDescriptorTypeStepCounter`.
* Added `initWithCoder` initializer to `XLFormViewController`. [#32](https://github.com/xmartlabs/XLForm/issues/32 "#32").
* Added a convenience method to deselect a `XLFormRowDescriptor`. `-(void)deselectFormRow:(XLFormRowDescriptor *)row;`. [#33](https://github.com/xmartlabs/XLForm/issues/33 "#33").


### Version 1.0.0 

* Initial release