//
//  XLFormStepCounterCell.m
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


#import "XLFormStepCounterCell.h"
#import "XLFormRowDescriptor.h"
#import "UIView+XLFormAdditions.h"

@interface XLFormStepCounterCell ()

@property (nonatomic) UIStepper *stepControl;
@property (nonatomic) UILabel *currentStepValue;

@end

@implementation XLFormStepCounterCell


#pragma mark - XLFormStepCounterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Add subviews
    [self.contentView addSubview:self.stepControl];
    [self.contentView addSubview:self.currentStepValue];
    
    // Add constraints
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.stepControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.currentStepValue attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.stepControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[value]-5-[control]-|" options:0 metrics:0 views:@{@"value": self.currentStepValue, @"control":self.stepControl}]];
}
 
- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.stepControl.value = [self.rowDescriptor.value doubleValue];
    self.currentStepValue.text = self.rowDescriptor.value ? [NSString stringWithFormat:@"%@", self.rowDescriptor.value] : nil;
    [self stepControl].enabled = !self.rowDescriptor.isDisabled;
    [self currentStepValue].font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGFloat red, green, blue, alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    if (self.rowDescriptor.isDisabled)
    {
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.3]];
        [self currentStepValue].textColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.3];
    }
    else{
        [self setTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
        [self currentStepValue].textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
}


#pragma mark - Events

- (void)valueChanged:(id)sender
{
    UIStepper *stepper = self.stepControl;
    
    self.rowDescriptor.value = @(stepper.value);
    self.currentStepValue.text = [NSString stringWithFormat:@"%.f", stepper.value];
}


#pragma mark - Properties

- (UIStepper *)stepControl
{
    if (!_stepControl) {
        _stepControl = [UIStepper autolayoutView];
        [_stepControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _stepControl;
}

-(UILabel *)currentStepValue
{
    if (!_currentStepValue) {
        _currentStepValue = [UILabel autolayoutView];
    }
    return _currentStepValue;
}

@end


