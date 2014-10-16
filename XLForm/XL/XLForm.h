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
#import "XLFormSliderCell.h"

//Validation
#import "XLFormRegexValidator.h"


extern NSString *const XLFormRowDescriptorTypeText;
extern NSString *const XLFormRowDescriptorTypeName;
extern NSString *const XLFormRowDescriptorTypeURL;
extern NSString *const XLFormRowDescriptorTypeEmail;
extern NSString *const XLFormRowDescriptorTypePassword;
extern NSString *const XLFormRowDescriptorTypeNumber;
extern NSString *const XLFormRowDescriptorTypePhone;
extern NSString *const XLFormRowDescriptorTypeTwitter;
extern NSString *const XLFormRowDescriptorTypeAccount;
extern NSString *const XLFormRowDescriptorTypeInteger;
extern NSString *const XLFormRowDescriptorTypeDecimal;
extern NSString *const XLFormRowDescriptorTypeTextView;
extern NSString *const XLFormRowDescriptorTypeSelectorPush;
extern NSString *const XLFormRowDescriptorTypeSelectorPopover;
extern NSString *const XLFormRowDescriptorTypeSelectorActionSheet;
extern NSString *const XLFormRowDescriptorTypeSelectorAlertView;
extern NSString *const XLFormRowDescriptorTypeSelectorPickerView;
extern NSString *const XLFormRowDescriptorTypeSelectorPickerViewInline;
extern NSString *const XLFormRowDescriptorTypeMultipleSelector;
extern NSString *const XLFormRowDescriptorTypeMultipleSelectorPopover;
extern NSString *const XLFormRowDescriptorTypeSelectorLeftRight;
extern NSString *const XLFormRowDescriptorTypeSelectorSegmentedControl;
extern NSString *const XLFormRowDescriptorTypeDateInline;
extern NSString *const XLFormRowDescriptorTypeDateTimeInline;
extern NSString *const XLFormRowDescriptorTypeTimeInline;
extern NSString *const XLFormRowDescriptorTypeDate;
extern NSString *const XLFormRowDescriptorTypeDateTime;
extern NSString *const XLFormRowDescriptorTypeTime;
extern NSString *const XLFormRowDescriptorTypeDatePicker;
extern NSString *const XLFormRowDescriptorTypePicker;
extern NSString *const XLFormRowDescriptorTypeSlider;
extern NSString *const XLFormRowDescriptorTypeBooleanCheck;
extern NSString *const XLFormRowDescriptorTypeBooleanSwitch;
extern NSString *const XLFormRowDescriptorTypeButton;
extern NSString *const XLFormRowDescriptorTypeInfo;
extern NSString *const XLFormRowDescriptorTypeStepCounter;


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending


