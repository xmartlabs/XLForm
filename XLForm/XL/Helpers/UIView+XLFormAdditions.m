//
//  UIView+XLFormAdditions.m
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

#import "UIView+XLFormAdditions.h"

@implementation UIView (XLFormAdditions)

+ (instancetype)autolayoutView
{
    __kindof UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    return view;
}

- (NSLayoutConstraint *)layoutConstraintSameHeightOf:(UIView *)view
{
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0
                                         constant:0.0];
}

- (UIView *)findFirstResponder
{
    UIView *firstResponder = nil;
    if (self.isFirstResponder) {
        firstResponder = self;
    }
    else {
        for (UIView *subView in self.subviews) {
            UIView *fr = [subView findFirstResponder];
            if (fr != nil) {
                firstResponder = fr;
                
                break;
            }
        }
    }
    
    return firstResponder;
}

- (UITableViewCell<XLFormDescriptorCell> *)formDescriptorCell
{
    UITableViewCell<XLFormDescriptorCell> * tableViewCell = nil;
    
    if ([self isKindOfClass:[UITableViewCell class]]) {
        if ([self conformsToProtocol:@protocol(XLFormDescriptorCell)]){
            tableViewCell = (UITableViewCell<XLFormDescriptorCell> *)self;
        }
    }
    else if (self.superview) {
        UITableViewCell<XLFormDescriptorCell> * cell = [self.superview formDescriptorCell];
        if (cell != nil) {
            tableViewCell = cell;
        }
    }
    
    return tableViewCell;
}

@end
