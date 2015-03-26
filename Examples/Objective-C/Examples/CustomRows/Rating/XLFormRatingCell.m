//  XLFormRatingCell.m
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

#import "XLFormRatingCell.h"

NSString * const XLFormRowDescriptorTypeRate = @"XLFormRowDescriptorTypeRate";

@implementation XLFormRatingCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormRatingCell class]) forKey:XLFormRowDescriptorTypeRate];
}

- (void)configure
{
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.ratingView addTarget:self action:@selector(rateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    [super update];
    
    self.ratingView.value = [self.rowDescriptor.value floatValue];
    self.rateTitle.text = self.rowDescriptor.title;
    
    [self.ratingView setAlpha:((self.rowDescriptor.isDisabled) ? .6 : 1)];
    [self.rateTitle setAlpha:((self.rowDescriptor.isDisabled) ? .6 : 1)];
}

#pragma mark - Events

-(void)rateChanged:(AXRatingView *)ratingView
{
    self.rowDescriptor.value = [NSNumber numberWithFloat:ratingView.value];
}

@end
