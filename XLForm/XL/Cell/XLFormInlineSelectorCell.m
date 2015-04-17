//
//  XLFormInlineSelectorCell.m
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

#import "XLForm.h"
#import "XLFormInlineSelectorCell.h"

@interface XLFormInlineSelectorCell()

@end

@implementation XLFormInlineSelectorCell
{
    UIColor * _beforeChangeColor;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    _beforeChangeColor = self.detailTextLabel.textColor;
    BOOL result = [super becomeFirstResponder];
    if (result){
        XLFormRowDescriptor * inlineRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes][self.rowDescriptor.rowType]];
        UITableViewCell<XLFormDescriptorCell> * cell = [inlineRowDescriptor cellForFormController:self.formViewController];
        NSAssert([cell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)], @"inline cell must conform to XLFormInlineRowDescriptorCell");
        UITableViewCell<XLFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<XLFormInlineRowDescriptorCell> *)cell;
        inlineCell.inlineRowDescriptor = self.rowDescriptor;
        [self.rowDescriptor.sectionDescriptor addFormRow:inlineRowDescriptor afterRow:self.rowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
    NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
    XLFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
    XLFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
    BOOL result = [super resignFirstResponder];
    [formSection removeFormRow:nextFormRow];
    return result;
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !(self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{

    if ([self isFirstResponder]){
        [self resignFirstResponder];
        return NO;
    }
    return [self becomeFirstResponder];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

-(void)highlight
{
    [super highlight];
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    self.detailTextLabel.textColor = _beforeChangeColor;
}

#pragma mark - Helpers

-(NSString *)valueDisplayText
{
    return (self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText);
}



@end
