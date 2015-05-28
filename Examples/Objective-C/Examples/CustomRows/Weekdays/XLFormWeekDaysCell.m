//  XLFormWeekDaysCell.m
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

#import "XLFormWeekDaysCell.h"

NSString * const XLFormRowDescriptorTypeWeekDays = @"XLFormRowDescriptorTypeWeekDays";

NSString *const kSunday= @"sunday";
NSString *const kMonday = @"monday";
NSString *const kTuesday = @"tuesday";
NSString *const kWednesday = @"wednesday";
NSString *const kThursday = @"thursday";
NSString *const kFriday = @"friday";
NSString *const kSaturday = @"saturday";

@interface XLFormWeekDaysCell()
@property (weak, nonatomic) IBOutlet UIButton *sundayButton;
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;
@property (weak, nonatomic) IBOutlet UIButton *saturdayButton;
@end

@implementation XLFormWeekDaysCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormWeekDaysCell class]) forKey:XLFormRowDescriptorTypeWeekDays];
}

#pragma mark - XLFormDescriptorCell

- (void)configure
{
    [super configure];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureButtons];
}

-(void)update
{
    [super update];
    [self updateButtons];
}

#pragma mark - Action

- (IBAction)dayTapped:(id)sender {
    [self dayTapped:sender day:[self getDayFormButton:sender]];
}

#pragma mark - Helpers

-(void)configureButtons
{
    for (UIView *subview in self.contentView.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton * button = (UIButton *)subview;
            [button setImage:[UIImage imageNamed:@"uncheckedDay"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"checkedDay"] forState:UIControlStateSelected];
            button.adjustsImageWhenHighlighted = NO;
            [self imageTopTitleBottom:button];
        }
    }
}

-(void)updateButtons
{
    NSDictionary * value = self.rowDescriptor.value;
    self.sundayButton.selected = [[value objectForKey:kSunday] boolValue];
    self.mondayButton.selected = [[value objectForKey:kMonday] boolValue];
    self.tuesdayButton.selected = [[value objectForKey:kTuesday] boolValue];
    self.wednesdayButton.selected = [[value objectForKey:kWednesday] boolValue];
    self.thursdayButton.selected = [[value objectForKey:kThursday] boolValue];
    self.fridayButton.selected = [[value objectForKey:kFriday] boolValue];
    self.saturdayButton.selected = [[value objectForKey:kSaturday] boolValue];
    
    [self.sundayButton setAlpha:((self.rowDescriptor.isDisabled) ? .6 : 1)];
    [self.mondayButton setAlpha:self.sundayButton.alpha];
    [self.tuesdayButton setAlpha:self.sundayButton.alpha];
    [self.wednesdayButton setAlpha:self.sundayButton.alpha];
    [self.thursdayButton setAlpha:self.sundayButton.alpha];
    [self.fridayButton setAlpha:self.sundayButton.alpha];
    [self.saturdayButton setAlpha:self.sundayButton.alpha];
}

-(NSString *)getDayFormButton:(id)sender
{
    if (sender == self.sundayButton) return kSunday;
    if (sender == self.mondayButton) return kMonday;
    if (sender == self.tuesdayButton) return kTuesday;
    if (sender == self.wednesdayButton) return kWednesday;
    if (sender == self.thursdayButton) return kThursday;
    if (sender == self.fridayButton) return kFriday;
    return kSaturday;
}

-(void)dayTapped:(UIButton *)button day:(NSString *)day
{
    button.selected = !button.selected;
    NSMutableDictionary * value = [self.rowDescriptor.value mutableCopy];
    [value setObject:@(button.selected) forKey:day];
    self.rowDescriptor.value = value;
}

-(void)imageTopTitleBottom:(UIButton *)button
{
    // the space between the image and text
    CGFloat spacing = 3.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
}


@end
