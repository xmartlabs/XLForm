//
//  XLFormMultipleButtonsCell..
//  XLForm
//
//  Created by Saqib Saud on 27/12/16.
//  Copyright © 2016 WiseSabre. All rights reserved.
//

#import "XLFormRowDescriptor.h"
#import "XLFormMultipleButtonsCell.h"
#import <QuartzCore/QuartzCore.h>

NSString * const XLFormRowDescriptorTypeMultipleButtons = @"XLFormRowDescriptorTypeMultipleButtons";
NSString * const XLFormRowDescriptorTypeMultipleButtonsControl = @"XLFormRowDescriptorTypeMultipleButtonsControl";

@interface XLFormMultipleButtonsCell ()
-(UIButton *)buttonWithTitle:(NSString *) title;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;

@end

@implementation XLFormMultipleButtonsCell
{
    UITextField * _constraintTextField;
}

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormMultipleButtonsCell class]) forKey:XLFormRowDescriptorTypeMultipleButtons];
    [XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes setObject:XLFormRowDescriptorTypeMultipleButtonsControl forKey:XLFormRowDescriptorTypeMultipleButtons];
}

#pragma mark - Properties

-(UIButton *)buttonWithTitle:(NSString *) title;
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateDisabled];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //    [button setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    button.backgroundColor = [UIColor grayColor];
    button.layer.cornerRadius = 5;
    return button;
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    self.buttonOk.layer.cornerRadius = 5;
    self.buttonCancel.layer.cornerRadius = 5;
    
    
}

-(void)update
{
    [super update];
    if (self.rowDescriptor.selectorOptions.count == 2) { // We have only 2 buttons
        [self.buttonCancel setTitle:[self.rowDescriptor.selectorOptions[0] displayText] forState:UIControlStateNormal];
        [self.buttonCancel setTitle:[self.rowDescriptor.selectorOptions[0] displayText] forState:UIControlStateDisabled];
        [self.buttonOk setTitle:[self.rowDescriptor.selectorOptions[1] displayText] forState:UIControlStateNormal];
        [self.buttonOk setTitle:[self.rowDescriptor.selectorOptions[1] displayText] forState:UIControlStateDisabled];
    }
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}


#pragma mark - Actions


-(IBAction)buttonPressed:(UIButton *)button
{
    self.rowDescriptor.value = @(button.tag);
    [self.formViewController didSelectFormRow:self.rowDescriptor];
}



@end
