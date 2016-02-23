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

extern NSString * __nonnull const XLFormErrorDomain;
extern NSString * __nonnull const XLValidationStatusErrorKey;

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

@property (readonly, nonatomic, nonnull) NSMutableArray * formSections;
@property (readonly, nullable) NSString * title;
@property (nonatomic) BOOL endEditingTableViewOnScroll;
@property (nonatomic) BOOL assignFirstResponderOnShow;
@property (nonatomic) BOOL addAsteriskToRequiredRowsTitle;
@property (getter=isDisabled) BOOL disabled;
@property (nonatomic) XLFormRowNavigationOptions rowNavigationOptions;

@property (weak, nullable) id<XLFormDescriptorDelegate> delegate;

+(nonnull instancetype)formDescriptor;
+(nonnull instancetype)formDescriptorWithTitle:(nullable NSString *)title;

-(void)addFormSection:(nonnull XLFormSectionDescriptor *)formSection;
-(void)addFormSection:(nonnull XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)addFormSection:(nonnull XLFormSectionDescriptor *)formSection afterSection:(nonnull XLFormSectionDescriptor *)afterSection;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow beforeRow:(nonnull XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow beforeRowTag:(nonnull NSString *)afterRowTag;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow afterRow:(nonnull XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow afterRowTag:(nonnull NSString *)afterRowTag;
-(void)removeFormSectionAtIndex:(NSUInteger)index;
-(void)removeFormSection:(nonnull XLFormSectionDescriptor *)formSection;
-(void)removeFormRow:(nonnull XLFormRowDescriptor *)formRow;
-(void)removeFormRowWithTag:(nonnull NSString *)tag;

-(nullable XLFormRowDescriptor *)formRowWithTag:(nonnull NSString *)tag;
-(nullable XLFormRowDescriptor *)formRowAtIndex:(nonnull NSIndexPath *)indexPath;
-(nullable XLFormRowDescriptor *)formRowWithHash:(NSUInteger)hash;
-(nullable XLFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index;

-(nullable NSIndexPath *)indexPathOfFormRow:(nonnull XLFormRowDescriptor *)formRow;

-(nonnull NSDictionary *)formValues;
-(nonnull NSDictionary *)httpParameters:(nonnull XLFormViewController *)formViewController;

-(nonnull NSArray *)localValidationErrors:(nonnull XLFormViewController *)formViewController;
-(void)setFirstResponder:(nonnull XLFormViewController *)formViewController;

-(nullable XLFormRowDescriptor *)nextRowDescriptorForRow:(nonnull XLFormRowDescriptor *)currentRow;
-(nullable XLFormRowDescriptor *)previousRowDescriptorForRow:(nonnull XLFormRowDescriptor *)currentRow;

-(void)forceEvaluate;

@end
