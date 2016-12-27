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

@implementation XLFormMultipleButtonsCell
{
    UITextField * _constraintTextField;
}
@synthesize button = _button;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormMultipleButtonsCell class] forKey:XLFormRowDescriptorTypeMultipleButtons];
    [XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes setObject:XLFormRowDescriptorTypeMultipleButtonsControl forKey:XLFormRowDescriptorTypeMultipleButtons];
}

#pragma mark - Properties

-(UIButton *)button
{
    if (_button) return _button;
    _button = [[UIButton alloc] init];
    [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_button setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    
    _button.layer.cornerRadius = 5;
    return _button;
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.button];
    
    [self.button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    for (id option in self.rowDescriptor.selectorOptions) {
//        [actionSheet addButtonWithTitle:[option displayText]];
//    }
    NSDictionary * views = @{@"button" : self.button};
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[button]-10-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}

-(void)update
{
    [super update];
    self.button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self.button setTitle:[self.rowDescriptor title] forState:UIControlStateNormal];
    [self.button setEnabled:!self.rowDescriptor.isDisabled];
    
    self.selectionStyle = self.rowDescriptor.isDisabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}


#pragma mark - Actions


-(void)leftButtonPressed:(UIButton *)leftButton
{
    [self.formViewController didSelectFormRow:self.rowDescriptor];
}



@end
