//
//  XLFormButtonCell.m
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
#import "XLFormButtonCell.h"

@implementation XLFormButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.textLabel.textAlignment = self.rowDescriptor.buttonViewController ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    self.accessoryType = self.rowDescriptor.buttonViewController ? UITableViewCellAccessoryDisclosureIndicator: UITableViewCellAccessoryNone;
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.selectionStyle = self.rowDescriptor.disabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;

}


-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    BOOL hasAction = self.rowDescriptor.action.formBlock || self.rowDescriptor.action.formSelector;
    if (hasAction){
        if (self.rowDescriptor.action.formBlock){
            self.rowDescriptor.action.formBlock(self.rowDescriptor);
        }
        else{
            [controller performFormSeletor:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
        }
    }
    else if (self.rowDescriptor.buttonViewController){
        if (controller.navigationController == nil || [self.rowDescriptor.buttonViewController isSubclassOfClass:[UINavigationController class]] || self.rowDescriptor.buttonViewControllerPresentationMode == XLFormPresentationModePresent){
            [controller presentViewController:[[self.rowDescriptor.buttonViewController alloc] init] animated:YES completion:nil];
        }
        else{
            [controller.navigationController pushViewController:[[self.rowDescriptor.buttonViewController alloc] init] animated:YES];
        }
    }
}


@end
