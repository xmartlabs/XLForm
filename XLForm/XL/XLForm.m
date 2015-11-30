//
//  XLForm.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "XLForm.h"

NSString *const XLFormRowDescriptorTypeText = @"text";
NSString *const XLFormRowDescriptorTypeName = @"name";
NSString *const XLFormRowDescriptorTypeURL = @"url";
NSString *const XLFormRowDescriptorTypeEmail = @"email";
NSString *const XLFormRowDescriptorTypePassword = @"password";
NSString *const XLFormRowDescriptorTypeNumber = @"number";
NSString *const XLFormRowDescriptorTypePhone = @"phone";
NSString *const XLFormRowDescriptorTypeTwitter = @"twitter";
NSString *const XLFormRowDescriptorTypeAccount = @"account";
NSString *const XLFormRowDescriptorTypeInteger = @"integer";
NSString *const XLFormRowDescriptorTypeImage = @"image";
NSString *const XLFormRowDescriptorTypeDecimal = @"decimal";
NSString *const XLFormRowDescriptorTypeTextView = @"textView";
NSString *const XLFormRowDescriptorTypeZipCode = @"zipCode";
NSString *const XLFormRowDescriptorTypeSelectorPush = @"selectorPush";
NSString *const XLFormRowDescriptorTypeSelectorPopover = @"selectorPopover";
NSString *const XLFormRowDescriptorTypeSelectorActionSheet = @"selectorActionSheet";
NSString *const XLFormRowDescriptorTypeSelectorAlertView = @"selectorAlertView";
NSString *const XLFormRowDescriptorTypeSelectorPickerView = @"selectorPickerView";
NSString *const XLFormRowDescriptorTypeSelectorPickerViewInline = @"selectorPickerViewInline";
NSString *const XLFormRowDescriptorTypeMultipleSelector = @"multipleSelector";
NSString *const XLFormRowDescriptorTypeMultipleSelectorPopover = @"multipleSelectorPopover";
NSString *const XLFormRowDescriptorTypeSelectorLeftRight = @"selectorLeftRight";
NSString *const XLFormRowDescriptorTypeSelectorSegmentedControl = @"selectorSegmentedControl";
NSString *const XLFormRowDescriptorTypeDateInline = @"dateInline";
NSString *const XLFormRowDescriptorTypeDateTimeInline = @"datetimeInline";
NSString *const XLFormRowDescriptorTypeTimeInline = @"timeInline";
NSString *const XLFormRowDescriptorTypeCountDownTimerInline = @"countDownTimerInline";
NSString *const XLFormRowDescriptorTypeDate = @"date";
NSString *const XLFormRowDescriptorTypeDateTime = @"datetime";
NSString *const XLFormRowDescriptorTypeTime = @"time";
NSString *const XLFormRowDescriptorTypeCountDownTimer = @"countDownTimer";
NSString *const XLFormRowDescriptorTypeDatePicker = @"datePicker";
NSString *const XLFormRowDescriptorTypePicker = @"picker";
NSString *const XLFormRowDescriptorTypeSlider = @"slider";
NSString *const XLFormRowDescriptorTypeBooleanCheck = @"booleanCheck";
NSString *const XLFormRowDescriptorTypeBooleanSwitch = @"booleanSwitch";
NSString *const XLFormRowDescriptorTypeButton = @"button";
NSString *const XLFormRowDescriptorTypeInfo = @"info";
NSString *const XLFormRowDescriptorTypeStepCounter = @"stepCounter";

