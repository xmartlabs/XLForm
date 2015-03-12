//
//  XLFormWeekDaysCell.m
//  XLForm
//
//  Created by Gaston Borba on 3/11/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "XLFormWeekDaysCell.h"

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



#pragma mark - XLFormDescriptorCell

- (void)awakeFromNib {
    // Initialization code
    
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
