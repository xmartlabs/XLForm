//
//  XLFormSectionDescriptor.h
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

#import "XLFormRowDescriptor.h"
#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, XLFormSectionOptions) {
    XLFormSectionOptionNone        = 0,
    XLFormSectionOptionCanInsert   = 1 << 0,
    XLFormSectionOptionCanDelete   = 1 << 1,
    XLFormSectionOptionCanReorder  = 1 << 2
};

typedef NS_ENUM(NSUInteger, XLFormSectionInsertMode) {
    XLFormSectionInsertModeLastRow = 0,
    XLFormSectionInsertModeButton = 2
};

@class XLFormDescriptor;

@interface XLFormSectionDescriptor : NSObject

@property (nonatomic, nullable) NSString * title;
@property (nonatomic, nullable) NSString * footerTitle;
@property (readonly, nonnull) NSMutableArray * formRows;

@property (readonly) XLFormSectionInsertMode sectionInsertMode;
@property (readonly) XLFormSectionOptions sectionOptions;
@property (nullable) XLFormRowDescriptor * multivaluedRowTemplate;
@property (readonly, nullable) XLFormRowDescriptor * multivaluedAddButton;
@property (nonatomic, nullable) NSString * multivaluedTag;

@property (weak, null_unspecified) XLFormDescriptor * formDescriptor;

@property (nonnull) id hidden;
-(BOOL)isHidden;

+(nonnull instancetype)formSection;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title multivaluedSection:(BOOL)multivaluedSection DEPRECATED_ATTRIBUTE DEPRECATED_MSG_ATTRIBUTE("Use formSectionWithTitle:sectionType: instead");
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(XLFormSectionOptions)sectionOptions;
+(nonnull instancetype)formSectionWithTitle:(nullable NSString *)title sectionOptions:(XLFormSectionOptions)sectionOptions sectionInsertMode:(XLFormSectionInsertMode)sectionInsertMode;

-(BOOL)isMultivaluedSection;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow afterRow:(nonnull XLFormRowDescriptor *)afterRow;
-(void)addFormRow:(nonnull XLFormRowDescriptor *)formRow beforeRow:(nonnull XLFormRowDescriptor *)beforeRow;
-(void)removeFormRowAtIndex:(NSUInteger)index;
-(void)removeFormRow:(nonnull XLFormRowDescriptor *)formRow;

@end
