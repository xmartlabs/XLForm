//
//  XLFormSectionDescriptor.h
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

#import "XLFormRowDescriptor.h"
#import <Foundation/Foundation.h>


@class XLFormDescriptor;

@interface XLFormSectionDescriptor : NSObject

@property (nonatomic) NSString * title;
@property (nonatomic) NSString * footerTitle;
@property (readonly) NSMutableArray * formRows;
@property BOOL isMultivaluedSection;
@property (nonatomic) NSString * multiValuedTag;

@property (weak) XLFormDescriptor * formDescriptor;

+(id)formSection;
+(id)formSectionWithTitle:(NSString *)title;
+(id)formSectionWithTitle:(NSString *)title multivaluedSection:(BOOL)multivaluedSection;

-(void)addFormRow:(XLFormRowDescriptor *)formRow;
-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRow:(XLFormRowDescriptor *)beforeRow;
-(void)removeFormRowAtIndex:(NSUInteger)index;
-(void)removeFormRow:(XLFormRowDescriptor *)formRow;

-(XLFormRowDescriptor *)newMultivaluedFormRowDescriptor;




@end
