//
//  DateAndTimeValueTrasformer.m
//  XLForm
//
//  Created by Martin Pastorin on 4/16/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "DateAndTimeValueTrasformer.h"


@implementation DateValueTrasformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSDate class]]){
        NSDate * date = (NSDate *)value;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

@end



@implementation DateTimeValueTrasformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSDate class]]){
        NSDate * date = (NSDate *)value;
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}

@end



@implementation DateAndTimeValueTrasformer

@end
