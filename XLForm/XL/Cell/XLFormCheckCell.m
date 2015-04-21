//
//  XLFormCheckCell.m
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

#import "XLFormCheckCell.h"

@implementation XLFormCheckCell

#pragma mark - XLFormDescriptorCell

- (void)configure
{
    [super configure];
    self.accessoryType = UITableViewCellAccessoryCheckmark;
    self.editingAccessoryType = self.accessoryType;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.accessoryType = [self.rowDescriptor.value boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    self.editingAccessoryType =  self.accessoryType;
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (self.rowDescriptor.isDisabled){
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.3]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    }
}
//

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    self.rowDescriptor.value = [NSNumber numberWithBool:![self.rowDescriptor.value boolValue]];
    [self.formViewController updateFormRow:self.rowDescriptor];
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

@end
