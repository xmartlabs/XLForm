//
//  XLFormDynamicHeightCell.m
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

#import "XLFormDynamicHeightCell.h"
#import "XLForm.h"

@implementation XLFormDynamicHeightCell

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.value;
}

+ (BOOL)formDescriptorCalculateCellHeight:(inout CGFloat *)height forRowDescriptor:(XLFormRowDescriptor *)rowDescriptor withFormController:(XLFormViewController *)controller
{
    CGFloat width = controller.tableView.bounds.size.width - 30;
    
    NSString *labelString = rowDescriptor.value;
    UIFont *labelFont = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [UIFont preferredFontForTextStyle:UIFontTextStyleBody] : [UIFont systemFontOfSize:[UIFont labelFontSize]]);
    NSDictionary *attributes = @{ NSFontAttributeName: labelFont };
    CGRect boundingRect = [labelString boundingRectWithSize:(CGSize){width, FLT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    *height = boundingRect.size.height + 24;
    return YES;
}

@end
