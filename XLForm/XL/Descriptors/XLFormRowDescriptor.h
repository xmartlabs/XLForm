//
//  XLFormRowDescriptor.h
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


#import "XLFormBaseCell.h"
#import <Foundation/Foundation.h>


@class XLFormViewController;
@class XLFormSectionDescriptor;

typedef NS_ENUM(NSUInteger, XLFormPresentationMode) {
    XLFormPresentationModeDefault = 0,
    XLFormPresentationModePush,
    XLFormPresentationModePresent
};

@interface XLFormRowDescriptor : NSObject

@property Class cellClass;
@property (readwrite) NSString *tag;
@property (readonly) NSString *rowType;
@property NSString *title;
@property (nonatomic) id value;
@property Class valueTransformer;
@property UITableViewCellStyle cellStype;

@property (nonatomic) NSMutableDictionary *cellConfig;
@property (nonatomic) NSMutableDictionary *cellConfigAtConfigure;
@property BOOL disabled;
@property BOOL required;

@property (weak) XLFormSectionDescriptor * sectionDescriptor;

-(id)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
+(XLFormRowDescriptor *)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType;
+(XLFormRowDescriptor *)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;

-(UITableViewCell<XLFormDescriptorCell> *)cellForFormController:(XLFormViewController *)formController;

// ================================
// properties for Button
// =================================
@property Class buttonViewController;
@property XLFormPresentationMode buttonViewControllerPresentationMode;


// ===========================
// property used for Selectors
// ===========================
@property NSString * noValueDisplayText;
@property NSString * selectorTitle;
@property NSArray * selectorOptions;

// =====================================
// properties used for dynamic selectors
// =====================================
@property Class selectorControllerClass;

@property id leftRightSelectorLeftOptionSelected;

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




