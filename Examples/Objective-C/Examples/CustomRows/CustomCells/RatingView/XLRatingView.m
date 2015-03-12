//
//  XLRatingView.m
//  XLForm
//
//  Created by Gaston Borba on 3/11/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//


#import "XLRatingView.h"

@implementation XLRatingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}

- (void)customize
{
    self.baseColor = [UIColor grayColor];
    self.highlightColor = [UIColor yellowColor];
    self.markFont = [UIFont systemFontOfSize:23.0f];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.stepInterval = 1.0f;
}

@end

