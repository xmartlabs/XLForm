//
//  XLFormValidator.h
//  XLForm
//
//  Created by Martin Barreto on 8/10/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLFormValidatorProtocol.h"

@interface XLFormValidator : NSObject<XLFormValidatorProtocol>

+(XLFormValidator *)emailValidator;
+(XLFormValidator *)websiteValidator;

@end
