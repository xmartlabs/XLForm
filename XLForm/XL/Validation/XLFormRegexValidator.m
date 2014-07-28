//
//  RegexValidator.m
//  XLForm
//
//  Created by Patrick Pöll on 23.07.14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLFormRegexValidator.h"

@implementation XLFormRegexValidator

- (id) initWithMsg:(NSString*) msg andRegexString: (NSString*) regex {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.regex = regex;
    }
    
    return self;
}

- (XLFormValidationStatus *) isValid: (XLFormRowDescriptor *) row {
    if (row != nil && row.value != nil &&  [row.value isKindOfClass:[NSString class]]) {
        // we only validate if there is a value
        // assumption: required validation is already triggered
        // if this field is optional, we only validate if there is a value
        if (row.value != nil && [row.value length] > 0) {
            BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.regex] evaluateWithObject:[row.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            return [XLFormValidationStatus formValidationStatusWithMsg:self.msg status:isValid];
        }
    }
    
    return nil;
};

+(XLFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex {
    return [[XLFormRegexValidator alloc] initWithMsg:msg andRegexString:regex];
}

@end
