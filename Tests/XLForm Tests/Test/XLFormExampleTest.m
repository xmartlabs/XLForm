//
//  XLFormViewControllerTestCase.m
//  XLForm Tests
//
//  Created by Gaston Borba on 3/23/15.
//
//


#import "XLTestCase.h"
#import <XLForm/XLFormTextFieldCell.h>
#import "UITextField+Test.h"

static NSString * const kTextFieldCellTag = @"TextFieldCellTag";

@interface XLFormExampleTest : XLTestCase
@end

@implementation XLFormExampleTest


- (void)testTableViewLoad
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;
    
    // Check if the tableView match with the form descriptor
    expect([tableView numberOfSections]).to.equal(1);
    expect([tableView numberOfRowsInSection:0]).to.equal(1);
    
    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // Check if the cell match with the XLFormRowDescriptorTypeText
    expect(cell).to.beKindOf([XLFormTextFieldCell class]);
    XLFormTextFieldCell * textFieldCell = (XLFormTextFieldCell *)cell;
    
    // Check if the title label match with the row descriptor title
    expect(textFieldCell.textLabel.text).to.equal(@"Title");
    // Check if the text field match with the row descriptor value
    expect(textFieldCell.textField.text).to.equal(@"");
}

- (void)testChangeFormDynamically
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;
    
    // Add a new section in the form descriptor
    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSectionWithTitle:@"Section"];
    [self.formController.form addFormSection:section];
    
    // Add a new row (switch) in the new section
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:XLFormRowDescriptorTypeBooleanSwitch rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Title"];
    [section addFormRow:row];
    
    // Check if the tableView match with the form descriptor
    expect([tableView numberOfSections]).to.equal(2);
    expect([tableView numberOfRowsInSection:0]).to.equal(1);
    expect([tableView numberOfRowsInSection:1]).to.equal(1);
    
    // Check if the cell match with the XLFormRowDescriptorTypeBooleanSwitch
    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    expect(cell).to.beKindOf([XLFormSwitchCell class]);
}

//- (void)testFillTextFieldCell
//{
//    // Get the tableView
//    UITableView * tableView = self.formController.tableView;
//    
//    // Get the cell that correspond to the row descriptor XLFormRowDescriptorTypeText
//    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    XLFormTextFieldCell * textFieldCell = (XLFormTextFieldCell *)cell;
//    // Get the texfield in the cell
//    UITextField * textField = textFieldCell.textField;
//    
//    // Simulate that change the text on the textfield
//    [textField changeText:@"Name"];
//    
//    // Get the row descriptor XLFormRowDescriptorTypeText
//    XLFormRowDescriptor * row = [self.formController.form formRowWithTag:kTextFieldCellTag];
//    
//    // Check if the text field match with the row descriptor value
//    expect(row.value).to.equal(@"Name");
//}

#pragma mark - Build Form

-(void)buildForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptor];
    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:kTextFieldCellTag rowType:XLFormRowDescriptorTypeText title:@"Title"];
    [section addFormRow:row];
    
    self.formController.form = form;
}

@end
