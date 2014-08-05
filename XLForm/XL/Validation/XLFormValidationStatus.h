//
//  XLFormValidationStatus.h
//  XLForm
//
//  Created by Patrick Pöll on 23.07.14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLFormValidationStatus : NSObject

@property NSString *msg;
@property BOOL isValid;

-(id)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid;
+(XLFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status;

@end
