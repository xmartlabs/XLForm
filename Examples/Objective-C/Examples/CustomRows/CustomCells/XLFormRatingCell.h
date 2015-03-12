//
//  XLFormRatingCell.h
//  XLForm
//
//  Created by Gaston Borba on 3/11/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "XLFormBaseCell.h"
#import "XLRatingView.h"

@interface XLFormRatingCell : XLFormBaseCell
@property (weak, nonatomic) IBOutlet UILabel *rateTitle;
@property (weak, nonatomic) IBOutlet XLRatingView *ratingView;

@end
