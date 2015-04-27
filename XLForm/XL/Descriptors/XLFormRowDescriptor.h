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

@interface XLFormRowDescriptor : NSObject

@property id cellClass;
@property (readwrite) NSString *tag;
@property (readonly) NSString *rowType;
@property NSString *title;
@property (nonatomic) id value;
@property Class valueTransformer;
@property UITableViewCellStyle cellStyle;

@property (nonatomic) NSMutableDictionary *cellConfig;
@property (nonatomic) NSMutableDictionary *cellConfigIfDisabled;
@property (nonatomic) NSMutableDictionary *cellConfigAtConfigure;

@property id disabled;
-(BOOL)isDisabled;
@property id hidden;
-(BOOL)isHidden;
@property (getter=isRequired) BOOL required;

@property XLFormAction * action;

@property (weak) XLFormSectionDescriptor * sectionDescriptor;

-(instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType;
+(instancetype)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

-(XLFormBaseCell *)cellForFormController:(XLFormViewController *)formController;

@property NSString *requireMsg;
-(void)addValidator:(id<XLFormValidatorProtocol>)validator;
-(void)removeValidator:(id<XLFormValidatorProtocol>)validator;
-(XLFormValidationStatus *)doValidation;

// ===========================
// property used for Selectors
// ===========================
@property NSString * noValueDisplayText;
@property NSString * selectorTitle;
@property NSArray * selectorOptions;

@property id leftRightSelectorLeftOptionSelected;


// =====================================
// Deprecated
// =====================================
@property Class buttonViewController DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use action.viewControllerClass instead");
@property XLFormPresentationMode buttonViewControllerPresentationMode DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("use action.viewControllerPresentationMode instead");
@property Class selectorControllerClass DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use action.viewControllerClass instead");


@end


// =====================================
// helper object used for LEFTRIGHTSelector Descriptor
// =====================================
@interface XLFormLeftRightSelectorOption : NSObject

@property (readonly) id leftValue;
@property (readonly) NSArray *  rightOptions;
@property (readonly) NSString * httpParameterKey;
@property Class rightSelectorControllerClass;

@property NSString * noValueDisplayText;
@property NSString * selectorTitle;


+(XLFormLeftRightSelectorOption *)formLeftRightSelectorOptionWithLeftValue:(id)leftValue
                                                          httpParameterKey:(NSString *)httpParameterKey
                                                              rightOptions:(NSArray *)rightOptions;


@end


@protocol XLFormOptionObject <NSObject>

@required

-(NSString *)formDisplayText;
-(id)formValue;

@end

@interface XLFormAction : NSObject

@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, strong) NSString * viewControllerStoryboardId;
@property (nonatomic, strong) NSString * viewControllerNibName;

@property (nonatomic) XLFormPresentationMode viewControllerPresentationMode;

@property (nonatomic, strong) void (^formBlock)(XLFormRowDescriptor * sender);
@property (nonatomic) SEL formSelector;
@property (nonatomic, strong) NSString * formSegueIdenfifier;
@property (nonatomic, strong) Class formSegueClass;

@end

