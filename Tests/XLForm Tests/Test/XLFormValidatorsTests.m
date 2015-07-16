//
//  XLFormValidatorsTests.m
//  XLForm Tests
//
//  Created by Martin Barreto on 8/5/14.
//
//

#import "XLTestCase.h"
#import <XCTest/XCTest.h>

@interface XLFormValidatorsTests : XLTestCase

@end

@implementation XLFormValidatorsTests

- (void)setUp
{
    [super setUp];
    [self buildForm];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRequiredTextField
{
    XLFormRowDescriptor * rowDescriptor = [self.formController.form formRowWithTag:XLFormRowDescriptorTypeText];
    
    expect([rowDescriptor doValidation].isValid).to.beFalsy();
}


#pragma mark - Build Form

-(void)buildForm
{
    self.formController = [[XLFormViewController alloc] init];
    self.formController.form = [XLFormDescriptor formDescriptor];
    
    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
    [self.formController.form addFormSection:section];
    
    XLFormRowDescriptor * row;
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:XLFormRowDescriptorTypeText rowType:XLFormRowDescriptorTypeText title:@"Required XLFormRowDescriptorTypeText"];
    row.required = YES;
    [section addFormRow:row];
    
}

@end
