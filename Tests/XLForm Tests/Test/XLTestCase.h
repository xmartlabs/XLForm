//
//  XLFormTestCase.h
//  XLForm Tests
//
//  Created by Martin Barreto on 8/5/14.
//
//

#import <XCTest/XCTest.h>

#define EXP_SHORTHAND YES
#import "Expecta.h"

#import <XLForm/XLForm.h>

@interface XLTestCase : XCTestCase

@property (nonatomic, strong) XLFormViewController * formController;

@end
