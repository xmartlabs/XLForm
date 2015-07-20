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

@property (readonly, nonatomic) NSMutableArray * __nonnull formSections;
@property (readonly) NSString * __nonnull title;
@property (nonatomic) BOOL assignFirstResponderOnShow;
@property (nonatomic) BOOL addAsteriskToRequiredRowsTitle;
@property (getter=isDisabled) BOOL disabled;
@property (nonatomic) XLFormRowNavigationOptions rowNavigationOptions;

@property (weak) id<XLFormDescriptorDelegate> __nullable delegate;

-(nonnull instancetype)initWithTitle:(NSString * __nullable)title;
+(nonnull instancetype)formDescriptor;
+(nonnull instancetype)formDescriptorWithTitle:(NSString * __nullable)title;

-(void)addFormSection:(XLFormSectionDescriptor * __nonnull)formSection;
-(void)addFormSection:(XLFormSectionDescriptor * __nonnull)formSection atIndex:(NSUInteger)index;
-(void)addFormSection:(XLFormSectionDescriptor * __nonnull)formSection afterSection:(XLFormSectionDescriptor * __nonnull)afterSection;
-(void)addFormRow:(XLFormRowDescriptor * __nonnull)formRow beforeRow:(XLFormRowDescriptor * __nonnull)afterRow;
-(void)addFormRow:(XLFormRowDescriptor * __nonnull)formRow beforeRowTag:(NSString * __nonnull)afterRowTag;
-(void)addFormRow:(XLFormRowDescriptor * __nonnull)formRow afterRow:(XLFormRowDescriptor * __nonnull)afterRow;
-(void)addFormRow:(XLFormRowDescriptor * __nonnull)formRow afterRowTag:(NSString * __nonnull)afterRowTag;
-(void)removeFormSectionAtIndex:(NSUInteger)index;
-(void)removeFormSection:(XLFormSectionDescriptor * __nonnull)formSection;
-(void)removeFormRow:(XLFormRowDescriptor * __nonnull)formRow;
-(void)removeFormRowWithTag:(NSString * __nonnull)tag;

-(XLFormRowDescriptor * __nullable)formRowWithTag:(NSString * __nonnull)tag;
-(XLFormRowDescriptor * __nullable)formRowAtIndex:(NSIndexPath * __nonnull)indexPath;
-(XLFormRowDescriptor * __nullable)formRowWithHash:(NSUInteger)hash;
-(XLFormSectionDescriptor * __nullable)formSectionAtIndex:(NSUInteger)index;

-(NSIndexPath * __nullable)indexPathOfFormRow:(XLFormRowDescriptor * __nonnull)formRow;

-(NSDictionary * __nonnull)formValues;
-(NSDictionary * __nonnull)httpParameters:(XLFormViewController * __nonnull)formViewController;

-(NSArray * __nonnull)localValidationErrors:(XLFormViewController * __nonnull)formViewController;
- (void)setFirstResponder:(XLFormViewController * __nonnull)formViewController;

-(XLFormRowDescriptor * __nullable)nextRowDescriptorForRow:(XLFormRowDescriptor * __nonnull)currentRow;
-(XLFormRowDescriptor * __nullable)previousRowDescriptorForRow:(XLFormRowDescriptor * __nonnull)currentRow;

-(void)forceEvaluate;

@end
