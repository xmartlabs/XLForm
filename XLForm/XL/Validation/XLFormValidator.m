//
//  XLFormValidator.m
//  XLForm
//
//  Created by Martin Barreto on 8/10/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLFormValidationStatus.h"
#import "XLFormRegexValidator.h"

#import "XLFormValidator.h"

@implementation XLFormValidator

-(XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row
{
    return [XLFormValidationStatus formValidationStatusWithMsg:nil status:YES];
}

#pragma mark - Validators


+(XLFormValidator *)emailValidator
{
    return [XLFormRegexValidator formRegexValidatorWithMsg:NSLocalizedString(@"Invalid email address", nil) regex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

@end
