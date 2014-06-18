//
//  XLForm.h
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
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

#import <Foundation/Foundation.h>

//Descriptors
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormRowDescriptor.h"

// Categories
#import "NSObject+XLFormAdditions.h"

//helpers
#import "XLFormOptionsObject.h"

//Controllers
#import "XLFormOptionsViewController.h"
#import "XLFormViewController.h"

//Protocols
#import "XLFormDescriptorCell.h"
#import "XLFormInlineRowDescriptorCell.h"
#import "XLFormRowDescriptorViewController.h"

//Cells
#import "XLFormBaseCell.h"
#import "XLFormInlineSelectorCell.h"
#import "XLFormTextFieldCell.h"
#import "XLFormTextViewCell.h"
#import "XLFormSelectorCell.h"
#import "XLFormDatePickerCell.h"
#import "XLFormButtonCell.h"
#import "XLFormSwitchCell.h"
#import "XLFormCheckCell.h"
#import "XLFormDatePickerCell.h"
#import "XLFormPickerCell.h"
#import "XLFormLeftRightSelectorCell.h"
#import "XLFormDateCell.h"
#import "XLFormStepCounterCell.h"
#import "XLFormSegmentedCell.h"


static NSString *const XLFormRowDescriptorTypeText = @"text";
static NSString *const XLFormRowDescriptorTypeName = @"name";
static NSString *const XLFormRowDescriptorTypeURL = @"url";
static NSString *const XLFormRowDescriptorTypeEmail = @"email";
static NSString *const XLFormRowDescriptorTypePassword = @"password";
static NSString *const XLFormRowDescriptorTypeNumber = @"number";
static NSString *const XLFormRowDescriptorTypePhone = @"phone";
static NSString *const XLFormRowDescriptorTypeTwitter = @"twitter";
static NSString *const XLFormRowDescriptorTypeAccount = @"account";
static NSString *const XLFormRowDescriptorTypeInteger = @"integer";
static NSString *const XLFormRowDescriptorTypeTextView = @"textView";
static NSString *const XLFormRowDescriptorTypeSelectorPush = @"selectorPush";
static NSString *const XLFormRowDescriptorTypeSelectorActionSheet = @"selectorActionSheet";
static NSString *const XLFormRowDescriptorTypeSelectorAlertView = @"selectorAlertView";
static NSString *const XLFormRowDescriptorTypeSelectorPickerView = @"selectorPickerView";
static NSString *const XLFormRowDescriptorTypeSelectorPickerViewInline = @"selectorPickerViewInline";
static NSString *const XLFormRowDescriptorTypeMultipleSelector = @"multipleSelector";
static NSString *const XLFormRowDescriptorTypeSelectorLeftRight = @"selectorLeftRight";
static NSString *const XLFormRowDescriptorTypeSelectorSegmentedControl = @"selectorSegmentedControl";
static NSString *const XLFormRowDescriptorTypeDateInline = @"dateInline";
static NSString *const XLFormRowDescriptorTypeDateTimeInline = @"datetimeInline";
static NSString *const XLFormRowDescriptorTypeTimeInline = @"timeInline";
static NSString *const XLFormRowDescriptorTypeDate = @"date";
static NSString *const XLFormRowDescriptorTypeDateTime = @"datetime";
static NSString *const XLFormRowDescriptorTypeTime = @"time";
static NSString *const XLFormRowDescriptorTypeDatePicker = @"datePicker";
static NSString *const XLFormRowDescriptorTypePicker = @"picker";
static NSString *const XLFormRowDescriptorTypeBooleanCheck = @"booleanCheck";
static NSString *const XLFormRowDescriptorTypeBooleanSwitch = @"booleanSwitch";
static NSString *const XLFormRowDescriptorTypeButton = @"button";
static NSString *const XLFormRowDescriptorTypeImage = @"image";
static NSString *const XLFormRowDescriptorTypeStepCounter = @"stepCounter";

