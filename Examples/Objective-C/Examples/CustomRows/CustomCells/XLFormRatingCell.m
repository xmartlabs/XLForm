//
//  XLFormRatingCell.m
//  XLForm
//
//  Created by Gaston Borba on 3/11/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "XLFormRatingCell.h"

@implementation XLFormRatingCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.ratingView addTarget:self action:@selector(rateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)update
{
    // update
    [super update];
    self.ratingView.value = [self.rowDescriptor.value floatValue];
    self.rateTitle.text = self.rowDescriptor.title;
}

#pragma mark - Events

-(void)rateChanged:(AXRatingView *)ratingView
{
    self.rowDescriptor.value = [NSNumber numberWithFloat:ratingView.value];
}

@end
