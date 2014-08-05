//
//  XLFormValidationProtocol.h
//  XLForm
//
//  Created by Patrick Pöll on 23.07.14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFormRowDescriptor.h"

@class XLFormValidationStatus;

@protocol XLFormValidatorProtocol <NSObject>

@required

-(XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row;

@end
