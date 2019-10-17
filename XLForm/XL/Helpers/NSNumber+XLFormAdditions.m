//
//  NSNumber+XLFormAdditions.m
//  XLForm ( https://github.com/MatteoMilesi/XLForm )
//
//  Copyright (c) 2017 MatteoMilesi
//

#import "NSNumber+XLFormAdditions.h"

@implementation NSNumber (XLFormAdditions)

-(NSString *)displayText
{
    return [NSString localizedStringWithFormat:@"%@", self];
}

@end
