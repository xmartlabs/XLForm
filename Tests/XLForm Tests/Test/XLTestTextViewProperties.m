//
//  XLTestTextViewProperties.m
//  XLForm Tests
//
//  Created by Claus on 9/5/16.
//
//

#import "XLTestCase.h"
#import <XLForm/XLFormTextViewCell.h>
#import <UIKit/UIKit.h>

@interface XLTestTextViewProperties : XLTestCase
@end

@implementation XLTestTextViewProperties

- (void)testPropertiesGetSet
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;
    
    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    // Check if the cell contains the correct properties
    expect(cell).to.beKindOf([XLFormTextViewCell class]);
    XLFormTextViewCell * textViewCell = (XLFormTextViewCell *)cell;
    expect(textViewCell.textViewLengthPercentage).to.equal(0.3);
    expect(textViewCell.textViewMaxNumberOfCharacters).to.equal(10);
}

- (void)testMaxNumbersOfCharacters
{
    // Get the tableView
    UITableView * tableView = self.formController.tableView;

    UITableViewCell * cell = [self.formController tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    expect(cell).to.beKindOf([XLFormTextViewCell class]);
    XLFormTextViewCell * textViewCell = (XLFormTextViewCell *)cell;

    // Check if range check works
    expect(cell).to.conformTo(@protocol(UITextViewDelegate));
    id<UITextViewDelegate> textFieldDelegate = (id<UITextViewDelegate>)cell;
    NSRange range = NSMakeRange(0, 0);
    expect([textFieldDelegate textView:textViewCell.textView shouldChangeTextInRange:range replacementText:@"123"]).to.beTruthy();
    expect([textFieldDelegate textView:textViewCell.textView shouldChangeTextInRange:range replacementText:@"1234567890"]).to.beTruthy();
    expect([textFieldDelegate textView:textViewCell.textView shouldChangeTextInRange:range replacementText:@"12345678901"]).to.beFalsy();
}

#pragma mark - Build Form

-(void)buildForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptor];
    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@(0.3) forKey:XLFormTextViewLengthPercentage];
    [row.cellConfigAtConfigure setObject:@(10) forKey:XLFormTextViewMaxNumberOfCharacters];
    [section addFormRow:row];
    
    self.formController.form = form;
}

@end
