//
//  XLFormRowDescriptor.h
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


#import <Foundation/Foundation.h>
#import "XLFormBaseCell.h"
#import "XLFormValidatorProtocol.h"
#import "XLFormValidationStatus.h"

extern CGFloat XLFormUnspecifiedCellHeight;

@class XLFormViewController;
@class XLFormSectionDescriptor;
@protocol XLFormValidatorProtocol;
@class XLFormAction;
@class XLFormBaseCell;

typedef NS_ENUM(NSUInteger, XLFormPresentationMode) {
    XLFormPresentationModeDefault = 0,
    XLFormPresentationModePush,
    XLFormPresentationModePresent
};

typedef void(^XLOnChangeBlock)(id __nullable oldValue, id __nullable newValue, XLFormRowDescriptor * __nonnull rowDescriptor);

@interface XLFormRowDescriptor : NSObject

@property (nonatomic, nullable, strong) id cellClass;
@property (nonatomic, nullable, copy  , readwrite) NSString * tag;
@property (nonatomic, nonnull , copy  , readonly) NSString * rowType;
@property (nonatomic, nullable, copy  ) NSString * title;
@property (nonatomic, nullable, strong) id value;
@property (nonatomic, nullable, strong) Class valueTransformer;
@property (nonatomic, assign  ) UITableViewCellStyle cellStyle;
@property (nonatomic, assign  ) CGFloat height;

@property (nonatomic, copy  , nullable) XLOnChangeBlock onChangeBlock;
@property (nonatomic, assign) BOOL useValueFormatterDuringInput;
@property (nonatomic, strong, nullable) NSFormatter *valueFormatter;

// returns the display text for the row descriptor, taking into account NSFormatters and default placeholder values
- (nonnull NSString *) displayTextValue;

// returns the editing text value for the row descriptor, taking into account NSFormatters.
- (nonnull NSString *) editTextValue;

@property (nonatomic, readonly, nonnull, strong) NSMutableDictionary * cellConfig;
@property (nonatomic, readonly, nonnull, strong) NSMutableDictionary * cellConfigForSelector;
@property (nonatomic, readonly, nonnull, strong) NSMutableDictionary * cellConfigIfDisabled;
@property (nonatomic, readonly, nonnull, strong) NSMutableDictionary * cellConfigAtConfigure;

@property (nonatomic, nonnull, strong) id disabled;
-(BOOL)isDisabled;

@property (nonatomic, nonnull, strong) id hidden;
-(BOOL)isHidden;

@property (getter=isRequired, nonatomic, assign) BOOL required;

@property (nonatomic, nonnull, strong) XLFormAction * action;

@property (nonatomic, weak, null_unspecified) XLFormSectionDescriptor * sectionDescriptor;

+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType;
+(nonnull instancetype)formRowDescriptorWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;
-(nonnull instancetype)initWithTag:(nullable NSString *)tag rowType:(nonnull NSString *)rowType title:(nullable NSString *)title;

-(nonnull XLFormBaseCell *)cellForFormController:(nonnull XLFormViewController *)formController;

@property (nonatomic, nullable, copy) NSString *requireMsg;
-(void)addValidator:(nonnull id<XLFormValidatorProtocol>)validator;
-(void)removeValidator:(nonnull id<XLFormValidatorProtocol>)validator;
-(nullable XLFormValidationStatus *)doValidation;

// ===========================
// property used for Selectors
// ===========================
@property (nonatomic, nullable, copy) NSString * noValueDisplayText;
@property (nonatomic, nullable, copy) NSString * selectorTitle;
@property (nonatomic, nullable, strong) NSArray * selectorOptions;

@property (null_unspecified) id leftRightSelectorLeftOptionSelected;


// =====================================
// Deprecated
// =====================================
@property (null_unspecified) Class buttonViewController DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use action.viewControllerClass instead");
@property XLFormPresentationMode buttonViewControllerPresentationMode DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("use action.viewControllerPresentationMode instead");
@property (null_unspecified) Class selectorControllerClass DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use action.viewControllerClass instead");


@end

typedef NS_ENUM(NSUInteger, XLFormLeftRightSelectorOptionLeftValueChangePolicy)
{
    XLFormLeftRightSelectorOptionLeftValueChangePolicyNullifyRightValue = 0,
    XLFormLeftRightSelectorOptionLeftValueChangePolicyChooseFirstOption,
    XLFormLeftRightSelectorOptionLeftValueChangePolicyChooseLastOption
};


// =====================================
// helper object used for LEFTRIGHTSelector Descriptor
// =====================================
@interface XLFormLeftRightSelectorOption : NSObject

@property (nonatomic, assign) XLFormLeftRightSelectorOptionLeftValueChangePolicy leftValueChangePolicy;
@property (nonatomic, readonly, nonnull) id leftValue;
@property (nonatomic, readonly, nonnull) NSArray *  rightOptions;
@property (nonatomic, readonly, null_unspecified, copy) NSString * httpParameterKey;
@property (nonatomic, nullable) Class rightSelectorControllerClass;

@property (nonatomic, nullable, copy) NSString * noValueDisplayText;
@property (nonatomic, nullable, copy) NSString * selectorTitle;


+(nonnull XLFormLeftRightSelectorOption *)formLeftRightSelectorOptionWithLeftValue:(nonnull id)leftValue
                                                          httpParameterKey:(null_unspecified NSString *)httpParameterKey
                                                              rightOptions:(nonnull NSArray *)rightOptions;


@end


@protocol XLFormOptionObject

@required

-(nonnull NSString *)formDisplayText;
-(nonnull id)formValue;

@end

@interface XLFormAction : NSObject

@property (nullable, nonatomic) Class viewControllerClass;
@property (nullable, nonatomic, copy) NSString * viewControllerStoryboardId;
@property (nullable, nonatomic, copy) NSString * viewControllerNibName;

@property (nonatomic, assign) XLFormPresentationMode viewControllerPresentationMode;

@property (nullable, nonatomic, copy) void (^formBlock)(XLFormRowDescriptor * __nonnull sender);
@property (nullable, nonatomic) SEL formSelector;
@property (nullable, nonatomic, copy) NSString * formSegueIdenfifier DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use formSegueIdentifier instead");
@property (nullable, nonatomic, copy) NSString * formSegueIdentifier;
@property (nullable, nonatomic) Class formSegueClass;

@end
