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
    BOOL leftAligmnment = self.rowDescriptor.action.viewControllerClass || [self.rowDescriptor.action.formSegueIdenfifier length] != 0 || self.rowDescriptor.action.formSegueClass;
    self.textLabel.textAlignment = leftAligmnment ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    self.accessoryType = leftAligmnment ? UITableViewCellAccessoryDisclosureIndicator: UITableViewCellAccessoryNone;
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.selectionStyle = self.rowDescriptor.disabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}


-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    BOOL hasAction = self.rowDescriptor.action.formBlock || self.rowDescriptor.action.formSelector || self.rowDescriptor.action.formSegueIdenfifier || self.rowDescriptor.action.formSegueClass;
    if (hasAction){
        if (self.rowDescriptor.action.formBlock){
            self.rowDescriptor.action.formBlock(self.rowDescriptor);
        }
        else if (self.rowDescriptor.action.formSelector){
            [controller performFormSeletor:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
        }
        else if ([self.rowDescriptor.action.formSegueIdenfifier length] != 0){
            [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
        }
        else if (self.rowDescriptor.action.formSegueClass){
            NSAssert(self.rowDescriptor.action.viewControllerClass, @"rowDescriptor.action.viewControllerClass must be assigned");
            UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:[[self.rowDescriptor.action.viewControllerClass alloc] init]];
            [controller prepareForSegue:segue sender:self.rowDescriptor];
            [segue perform];
        }
    }
    else if (self.rowDescriptor.action.viewControllerClass){
        if (controller.navigationController == nil || [self.rowDescriptor.action.viewControllerClass isSubclassOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
            [controller presentViewController:[[self.rowDescriptor.action.viewControllerClass alloc] init] animated:YES completion:nil];
        }
        else{
            [controller.navigationController pushViewController:[[self.rowDescriptor.action.viewControllerClass alloc] init] animated:YES];
        }
    }
}


@end
