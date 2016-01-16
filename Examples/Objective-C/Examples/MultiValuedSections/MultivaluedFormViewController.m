//
//  MultiValuedFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
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


@implementation MultivaluedFormViewController

- (id)init
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Multivalued Examples"];
    
    // Multivalued section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multivalued TextField"
                                             sectionOptions:XLFormSectionOptionCanReorder | XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.multivaluedAddButton.title = @"Add New Tag";
    section.footerTitle = @"XLFormSectionInsertModeButton sectionType adds a 'Add Item' (Add New Tag) button row as last cell.";
    // set up the row template
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeName];
    [[row cellConfig] setObject:@"Tag Name" forKey:@"textField.placeholder"];
    section.multivaluedRowTemplate = row;
    [form addFormSection:section];
    
    
    // Another Multivalued section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multivalued ActionSheet Selector example"
                                             sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete];
    section.footerTitle = @"XLFormSectionInsertModeLastRow sectionType adds a '+' icon inside last table view cell allowing us to add a new row.";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Tap to select.."];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5"];
    [section addFormRow:row];
    
    
    // Another one
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multivalued Push Selector example"
                                             sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete | XLFormSectionOptionCanReorder
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    section.footerTitle = @"MultivaluedFormViewController.h";
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPush title:@"Tap to select ;).."];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3"];
    section.multivaluedRowTemplate = [row copy];
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
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"Cancel")
                                                destructiveButtonTitle:@"Remove Last Section"
                                                     otherButtonTitles:@"Add a section at the end", self.form.isDisabled ? @"Enable Form" : @"Disable Form", nil];
    [actionSheet showInView:self.view];
#else
    if ([UIAlertController class]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak __typeof(self)weakSelf = self;
        [alertController addAction:[UIAlertAction actionWithTitle:@"Remove Last Section"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              if (weakSelf.form.formSections.count > 0){
                                                                  // remove last section
                                                                  [weakSelf.form removeFormSectionAtIndex:(weakSelf.form.formSections.count - 1)];
                                                              }
                                                          }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Add a section at the end"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              // add a new section
                                                              XLFormSectionDescriptor * newSection = [XLFormSectionDescriptor formSectionWithTitle:[NSString stringWithFormat:@"Section created at %@", [NSDateFormatter localizedStringFromDate:[NSDate new] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]] sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete];
                                                              newSection.multivaluedTag = [NSString stringWithFormat:@"multivaluedPushSelector_%@", @(weakSelf.form.formSections.count)];
                                                              XLFormRowDescriptor * newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPush title:@"Tap to select ;).."];
                                                              newRow.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3"];
                                                              [newSection addFormRow:newRow];
                                                              [weakSelf.form addFormSection:newSection];
                                                          }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:self.form.isDisabled ? @"Enable Form" : @"Disable Form"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              weakSelf.form.disabled = !weakSelf.form.disabled;
                                                              [weakSelf.tableView endEditing:YES];
                                                              [weakSelf.tableView reloadData];
                                                          }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                    destructiveButtonTitle:@"Remove Last Section"
                                                         otherButtonTitles:@"Add a section at the end", self.form.isDisabled ? @"Enable Form" : @"Disable Form", nil];
        [actionSheet showInView:self.view];
    }
#endif
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

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
        XLFormSectionDescriptor * newSection = [XLFormSectionDescriptor formSectionWithTitle:[NSString stringWithFormat:@"Section created at %@", [NSDateFormatter localizedStringFromDate:[NSDate new] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]] sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete];
        newSection.multivaluedTag = [NSString stringWithFormat:@"multivaluedPushSelector_%@", @(self.form.formSections.count)];
        XLFormRowDescriptor * newRow = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPush title:@"Tap to select ;).."];
        newRow.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3"];
        [newSection addFormRow:newRow];
        [self.form addFormSection:newSection];
    }
    else if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Cancel")]){
        self.form.disabled = !self.form.disabled;
        [self.tableView endEditing:YES];
        [self.tableView reloadData];
    }
}

#endif

@end


@implementation MultivaluedOnlyReorderViewController

- (id)init
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSArray * list = @[@"Today", @"Yesterday", @"Before Yesterday"];
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Only Reorder Examples"];
    
    
    // Multivalued Section with inline rows - section set up to support only reordering
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Reordering Inline Rows"
                                             sectionOptions:XLFormSectionOptionCanReorder];
    section.footerTitle = @"XLFormRowDescriptorTypeDateInline row type";
    [form addFormSection:section];
    
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeDateInline];
        row.value = [NSDate dateWithTimeIntervalSinceNow:(-secondsPerDay * idx)];
        row.title = obj;
        [section addFormRow:row];
    }];
    
    
    // Multivalued Section with common rows - section set up to support only reordering
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Reordering Rows"
                                             sectionOptions:XLFormSectionOptionCanReorder];
    section.footerTitle = @"XLFormRowDescriptorTypeInfo row type";
    [form addFormSection:section];
    
    
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeInfo];
        row.value = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSinceNow:(-secondsPerDay * idx)] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        row.title = obj;
        [section addFormRow:row];
    }];
    
    return [super initWithForm:form];
}

@end


@implementation MultivaluedOnlyInserViewController

- (id)init
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    NSArray * nameList = @[@"family", @"male", @"female", @"client"];
    
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Multivalued Only Insert"];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"XLFormSectionInsertModeButton"
                                             sectionOptions:XLFormSectionOptionCanInsert
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
    [[row cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
    section.multivaluedRowTemplate = row;
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"XLFormSectionInsertModeButton With Inline Cells"
                                             sectionOptions:XLFormSectionOptionCanInsert
                                          sectionInsertMode:XLFormSectionInsertModeButton];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeDateInline];
    row.value = [NSDate new];
    row.title = @"Date";
    section.multivaluedRowTemplate = row;
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"XLFormSectionInsertModeLastRow"
                                             sectionOptions:XLFormSectionOptionCanInsert
                                          sectionInsertMode:XLFormSectionInsertModeLastRow];
    [form addFormSection:section];
    for (NSString * tag in nameList) {
        // add a row to the section, the row will be used to crete new rows.
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
        [[row cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        row.value = tag;
        [section addFormRow:row];
    }
    
    return [super initWithForm:form];
}

@end


@implementation MultivaluedOnlyDeleteViewController

- (id)init
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    NSArray * nameList = @[@"family", @"male", @"female", @"client"];
    
    
    form = [XLFormDescriptor formDescriptor];
    
    // MultivaluedSection section
    section = [XLFormSectionDescriptor formSectionWithTitle:@""
                                             sectionOptions:XLFormSectionOptionCanDelete];
    section.footerTitle = @"you can swipe to delete when table.editing = NO (Not Editing)";
    [form addFormSection:section];
    
    for (NSString * tag in nameList) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText];
        [[row cellConfig] setObject:@"Add a new tag" forKey:@"textField.placeholder"];
        row.value = [tag copy];
        [section addFormRow:row];
    }
    
    // Multivalued Section with inline row.
    section = [XLFormSectionDescriptor formSectionWithTitle:@""
                                             sectionOptions:XLFormSectionOptionCanDelete];
    section.footerTitle = @"you can swipe to delete when table.editing = NO (Not Editing)";
    [form addFormSection:section];
    for (NSUInteger i = 0; i < 4; i++) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeSelectorPickerViewInline];
        row.title = @"Tap to select";
        row.value = @"client";
        row.selectorOptions = nameList;
        [section addFormRow:row];
    }
    
    return [super initWithForm:form];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Editing" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditing:)];
}


-(void)toggleEditing:(UIBarButtonItem *)barButtonItem
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [barButtonItem setTitle:(self.tableView.editing ? @"Editing" : @"Not Editing")];
}

@end

