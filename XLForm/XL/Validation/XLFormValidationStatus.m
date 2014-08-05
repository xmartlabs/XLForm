//
//  XLFormValidationStatus.m
//  XLForm
//
//  Created by Patrick Pöll on 23.07.14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLFormValidationStatus.h"

@implementation XLFormValidationStatus

-(id)initWithMsg:(NSString*)msg andStatus:(BOOL)isValid {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.isValid = isValid;
    }
    
    return self;
}

+(XLFormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status {
    return [[XLFormValidationStatus alloc] initWithMsg:msg andStatus:status];
}

@end
