//
//  XLTestTextFieldProperties.m
//  XLForm Tests
//
//  Created by Claus on 9/5/16.
//
//

#import "XLTestCase.h"
#import <XLForm/XLFormTextFieldCell.h>
#import <UIKit/UIKit.h>

@interface XLTestTextFieldProperties : XLTestCase
@end

@implementation XLTestTextFieldProperties

- (void)testPropertiesGetSet
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;
    
    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    // Check if the cell contains the correct properties
    expect(cell).to.beKindOf([XLFormTextFieldCell class]);
    XLFormTextFieldCell * textFieldCell = (XLFormTextFieldCell *)cell;
    expect(textFieldCell.textFieldLengthPercentage).to.equal(0.3);
    expect(textFieldCell.textFieldMaxNumberOfCharacters).to.equal(10);
}

- (void)testMaxNumbersOfCharacters
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;

    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    expect(cell).to.beKindOf([XLFormTextFieldCell class]);
    XLFormTextFieldCell * textFieldCell = (XLFormTextFieldCell *)cell;

    // Check if range check works
    expect(cell).to.conformTo(@protocol(UITextFieldDelegate));
    id<UITextFieldDelegate> textFieldDelegate = (id<UITextFieldDelegate>)cell;
    NSRange range = NSMakeRange(0, 0);
    expect([textFieldDelegate textField:textFieldCell.textField shouldChangeCharactersInRange:range replacementString:@"123"]).to.beTruthy();
    expect([textFieldDelegate textField:textFieldCell.textField shouldChangeCharactersInRange:range replacementString:@"1234567890"]).to.beTruthy();
    expect([textFieldDelegate textField:textFieldCell.textField shouldChangeCharactersInRange:range replacementString:@"12345678901"]).to.beFalsy();
}

#pragma mark - Build Form

-(void)buildForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptor];
    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@(0.3) forKey:XLFormTextFieldLengthPercentage];
    [row.cellConfigAtConfigure setObject:@(10) forKey:XLFormTextFieldMaxNumberOfCharacters];
    [section addFormRow:row];
    
    self.formController.form = form;
}

@end
