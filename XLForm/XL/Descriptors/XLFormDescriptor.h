//
//  XLFormDescriptor.h
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

#import "XLFormSectionDescriptor.h"
#import "XLFormRowDescriptor.h"
#import "XLFormDescriptorDelegate.h"
#import <Foundation/Foundation.h>

extern NSString * const XLFormErrorDomain;
extern NSString * const XLValidationStatusErrorKey;

typedef NS_ENUM(NSInteger, XLFormErrorCode)
{
    XLFormErrorCodeGen = -999,
    XLFormErrorCodeRequired = -1000
};

typedef NS_OPTIONS(NSUInteger, XLFormRowNavigationOptions) {
    XLFormRowNavigationOptionNone                               = 0,
    XLFormRowNavigationOptionEnabled                            = 1 << 0,
    XLFormRowNavigationOptionStopDisableRow                     = 1 << 1,
    XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow  = 1 << 2,
    XLFormRowNavigationOptionStopInlineRow                      = 1 << 3,
};

@class XLFormSectionDescriptor;

@interface XLFormDescriptor : NSObject

@property (readonly, nonatomic) NSMutableArray * formSections;
@property (readonly) NSString * title;
@property (nonatomic) BOOL assignFirstResponderOnShow;
@property (nonatomic) BOOL addAsteriskToRequiredRowsTitle;
@property (getter=isDisabled) BOOL disabled;
@property (nonatomic) XLFormRowNavigationOptions rowNavigationOptions;

@property (weak) id<XLFormDescriptorDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title;
+(instancetype)formDescriptor;
+(instancetype)formDescriptorWithTitle:(NSString *)title;

-(void)addFormSection:(XLFormSectionDescriptor *)formSection;
-(void)addFormSection:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)addFormSection:(XLFormSectionDescriptor *)formSection afterSection:(XLFormSectionDescriptor *)afterSection;
-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRow:(XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRowTag:(NSString *)afterRowTag;
-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRowTag:(NSString *)afterRowTag;
-(void)removeFormSectionAtIndex:(NSUInteger)index;
-(void)removeFormSection:(XLFormSectionDescriptor *)formSection;
-(void)removeFormRow:(XLFormRowDescriptor *)formRow;
-(void)removeFormRowWithTag:(NSString *)tag;

-(XLFormRowDescriptor *)formRowWithTag:(NSString *)tag;
-(XLFormRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath;
-(XLFormRowDescriptor *)formRowWithHash:(NSUInteger)hash;
-(XLFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;

-(NSIndexPath *)indexPathOfFormRow:(XLFormRowDescriptor *)formRow;

-(NSDictionary *)formValues;
-(NSDictionary *)httpParameters:(XLFormViewController *)formViewController;

-(NSArray *)localValidationErrors:(XLFormViewController *)formViewController;
- (void)setFirstResponder:(XLFormViewController *)formViewController;

-(XLFormRowDescriptor *)nextRowDescriptorForRow:(XLFormRowDescriptor *)currentRow;
-(XLFormRowDescriptor *)previousRowDescriptorForRow:(XLFormRowDescriptor *)currentRow;

-(void)forceEvaluate;

@end
