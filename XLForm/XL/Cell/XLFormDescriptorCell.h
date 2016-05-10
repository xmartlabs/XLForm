//
//  XLFormDescriptorCell.h
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

#import <UIKit/UIKit.h>


@class XLFormRowDescriptor;
@class XLFormViewController;

@protocol XLFormDescriptorCell <NSObject>

@required

@property (nonatomic, weak) XLFormRowDescriptor * rowDescriptor;
-(void)configure;
-(void)update;

@optional

// if return YES, only formDescriptorCalculateCellHeightEstimate.. (below) is used and height is derived from autolayout
+(BOOL)formDescriptorCellPrefersSelfSizingForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor withFormController:(XLFormViewController *)controller;

// height passed-in is table's default, update height if desired and return YES to use it
+(BOOL)formDescriptorCalculateCellHeight:(inout CGFloat *)height forRowDescriptor:(XLFormRowDescriptor *)rowDescriptor withFormController:(XLFormViewController *)controller;
+(BOOL)formDescriptorCalculateCellHeightEstimate:(inout CGFloat *)heightEstimate forRowDescriptor:(XLFormRowDescriptor *)rowDescriptor withFormController:(XLFormViewController *)controller;

// legacy cell height method, not called if methods above are implamented instead
+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor;

-(BOOL)formDescriptorCellCanBecomeFirstResponder;
-(BOOL)formDescriptorCellBecomeFirstResponder;
-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller;
-(NSString *)formDescriptorHttpParameterName;


-(void)highlight;
-(void)unhighlight;


@end
