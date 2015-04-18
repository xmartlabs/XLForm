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

@interface XLFormStepCounterCell ()

@end

@implementation XLFormStepCounterCell

#pragma mark - XLFormStepCounterCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    UIStepper *stepperControl = [[UIStepper alloc] initWithFrame:CGRectMake(25,
                                                                            0,
                                                                            0,
                                                                            0)];
    [stepperControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    UILabel *currentStepValue = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          25,
                                                                          CGRectGetHeight(stepperControl.frame))];
    
    currentStepValue.textAlignment = NSTextAlignmentCenter;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 CGRectGetWidth(stepperControl.frame) + CGRectGetWidth(currentStepValue.frame),
                                                                 CGRectGetHeight(stepperControl.frame))];

    [container addSubview:stepperControl];
    [container addSubview:currentStepValue];
    
    self.accessoryView = container;
    self.editingAccessoryView = container;
}
 
- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.stepControl.value = [self.rowDescriptor.value doubleValue];
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
    [self valueChanged:nil];
}
 
- (UIStepper *)stepControl
{
    for (UIView *view in self.accessoryView.subviews) {
        if ([view isMemberOfClass:[UIStepper class]]) {
            return (UIStepper *)view;
        }
    }
    
    return nil;
}

- (UILabel *)currentStepValue
{
    for (UIView *view in self.accessoryView.subviews) {
        if ([view isMemberOfClass:[UILabel class]]) {
            return (UILabel *)view;
        }
    }
    
    return nil;
}

- (void)valueChanged:(id)sender
{
    UIStepper *stepper = self.stepControl;
    
    self.rowDescriptor.value = stepper.value == 0 ? nil : @(stepper.value);
    self.currentStepValue.text = stepper.value == 0 ? nil : [NSString stringWithFormat:@"%.f", stepper.value];
}


@end


