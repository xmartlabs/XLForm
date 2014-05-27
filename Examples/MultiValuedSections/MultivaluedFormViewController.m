//
//  MultiValuedFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLForm.h"
#import "SelectorsFormViewController.h"
#import "MultiValuedFormViewController.h"


@implementation MultiValuedFormViewController

- (id)init
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    NSArray * nameList = @[@"family", @"male", @"female", @"client"];
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"MultiValued Examples"];
    
    // MultivaluedSection section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"MultiValued TextField" multivaluedSection:YES];
    section.multiValuedTag = @"textFieldRow";
    [form addFormSection:section];
    
    
    for (NSString * tag in nameList) {
        // add a row to the section, the row will be used to crete new rows.
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
        [[row cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        row.value = [tag copy];
        [section addFormRow:row];
    }
    // add a row to the section, the row will be used to crete new rows.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [[row cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    // Another MultivaluedSection section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"MultiValued ActionSheet Selector example" multivaluedSection:YES];
    section.multiValuedTag = @"actionSheetSelector";
    [form addFormSection:section];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Tap to select.."];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                                                 ];
    [section addFormRow:row];
    
    
    
    // Another one
    section = [XLFormSectionDescriptor formSectionWithTitle:@"MultiValued Push Selector example" multivaluedSection:YES];
    section.footerTitle = @"MultiValuedFormViewController.h";
    section.multiValuedTag = @"multivaluedPushSelector";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPush title:@"Tap to select ;).."];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                                                 [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"]
                                                 ];
    [section addFormRow:row];
    
    
    
    return [super initWithForm:form];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(addDidTouch:)];
}

#pragma mark - Actions

-(void)addDidTouch:(UIBarButtonItem * __unused)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Last Section" otherButtonTitles:@"Add a section at the end", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet destructiveButtonIndex] == buttonIndex){
        if (self.form.formSections.count > 0){
            // remove last section
            [self.form removeFormSectionAtIndex:(self.form.formSections.count - 1)];
        }
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add a section at the end"]){
        // add a new section
        XLFormSectionDescriptor * newSection = [XLFormSectionDescriptor formSectionWithTitle:[NSString stringWithFormat:@"Section created at %@", [NSDateFormatter localizedStringFromDate:[NSDate new] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]] multivaluedSection:YES];
        newSection.multiValuedTag = [NSString stringWithFormat:@"multivaluedPushSelector_%@", @(self.form.formSections.count)];
        XLFormRowDescriptor * newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPush title:@"Tap to select ;).."];
        newRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                                   [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                                   [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"]];
        [newSection addFormRow:newRow];
        [self.form addFormSection:newSection];
    }
}

@end
