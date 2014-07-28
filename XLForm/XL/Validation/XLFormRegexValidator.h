//
//  RegexValidator.h
//  XLForm
//
//  Created by Patrick Pöll on 23.07.14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFormValidatorProtocol.h"
#import "XLFormValidationStatus.h"

@interface XLFormRegexValidator : NSObject<XLFormValidatorProtocol>

@property NSString *msg;
@property NSString *regex;

- (id) initWithMsg:(NSString*) msg andRegexString:(NSString*) regex;
+ (XLFormRegexValidator *)formRegexValidatorWithMsg:(NSString *)msg regex:(NSString *)regex;

@end
