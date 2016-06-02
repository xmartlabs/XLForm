//
//  XLFormDescriptorDelegate.h
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

#import "XLFormDescriptor.h"
#import <Foundation/Foundation.h>

@class XLFormSectionDescriptor;

typedef NS_ENUM(NSUInteger, XLPredicateType) {
    XLPredicateTypeDisabled = 0,
    XLPredicateTypeHidden
};


@protocol XLFormDescriptorDelegate <NSObject>

@required

-(void)formSectionHasBeenRemoved:(nonnull XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formSectionHasBeenAdded:(nonnull XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index;
-(void)formRowHasBeenAdded:(nonnull XLFormRowDescriptor *)formRow atIndexPath:(nonnull NSIndexPath *)indexPath;
-(void)formRowHasBeenRemoved:(nonnull XLFormRowDescriptor *)formRow atIndexPath:(nonnull NSIndexPath *)indexPath;
-(void)formRowDescriptorValueHasChanged:(nonnull XLFormRowDescriptor *)formRow oldValue:(nonnull id)oldValue newValue:(nonnull id)newValue;
-(void)formRowDescriptorPredicateHasChanged:(nonnull XLFormRowDescriptor *)formRow
                                   oldValue:(nonnull id)oldValue
                                   newValue:(nonnull id)newValue
                              predicateType:(XLPredicateType)predicateType;

- (void)formRowDescriptor:(nonnull XLFormRowDescriptor *)formRow didAddSelectorOption:(nonnull id)option;
- (void)formRowDescriptor:(nonnull XLFormRowDescriptor *)formRow didDeleteSelectorOption:(nonnull id)option;
- (void)formRowDescriptor:(nonnull XLFormRowDescriptor *)formRow didChangeSelectorOption:(nonnull id)option newText:(nonnull NSString *)newText;
- (void)formRowDescriptor:(nonnull XLFormRowDescriptor *)formRow didSortSelectorOption:(nonnull id)option fromPosition:(int)fromPosition toPosition:(int)toPosition;

@end
