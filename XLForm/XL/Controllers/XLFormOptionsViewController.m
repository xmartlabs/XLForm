//
//  XLFormOptionsViewController.m
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

#import "NSObject+XLFormAdditions.h"
#import "XLFormOptionsViewController.h"
#import "XLFormRightDetailCell.h"
#import "XLForm.h"
#import "NSObject+XLFormAdditions.h"
#import "NSArray+XLFormAdditions.h"

#define CELL_REUSE_IDENTIFIER  @"OptionCell"

@interface XLFormOptionsViewController () <UITableViewDataSource>

@property NSString * titleHeaderSection;
@property NSString * titleFooterSection;


@end

@implementation XLFormOptionsViewController

@synthesize titleHeaderSection = _titleHeaderSection;
@synthesize titleFooterSection = _titleFooterSection;
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self){
        _titleFooterSection = nil;
        _titleHeaderSection = nil;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style titleHeaderSection:(NSString *)titleHeaderSection titleFooterSection:(NSString *)titleFooterSection
{
    self = [self initWithStyle:style];
    if (self){
        _titleFooterSection = titleFooterSection;
        _titleHeaderSection = titleHeaderSection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // register option cell
    [self.tableView registerClass:[XLFormRightDetailCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
}

- (void)setEditingOptionsEnabled:(BOOL)editingOptionsEnabled
{
    NSAssert(self.rowDescriptor.rowType != XLFormRowDescriptorTypeSelectorLeftRight, @"Editing selector options is currently not allowed for XLFormRowDescriptorTypeSelectorLeftRight row types.");

    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        _editingOptionsEnabled = editingOptionsEnabled;
        // enable editing
        if (_editingOptionsEnabled) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSAssert(self.rowDescriptor.rowType != XLFormRowDescriptorTypeSelectorLeftRight, @"Editing selector options is currently not allowed for XLFormRowDescriptorTypeSelectorLeftRight row types.");

    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        [super setEditing:editing animated:animated];
        
        [self.tableView setEditing:editing animated:YES];
        
        // allow cell selection when editing
        [self.tableView setAllowsSelectionDuringEditing:YES];
        
        // reload table to show the "add new" row
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        // avoid moving "add new" row
        if (indexPath.row > 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        if (sourceIndexPath.row != destinationIndexPath.row) {
            // retrieve selector options
            NSMutableArray *selectorOptions = [[self selectorOptions] mutableCopy];
            id sourceCellObject =  [[self selectorOptions] objectAtIndex:sourceIndexPath.row - 1]; // ignore "add new" row
            // move selector option from source to destination row
            [selectorOptions removeObjectAtIndex:sourceIndexPath.row - 1];
            [selectorOptions insertObject:sourceCellObject atIndex:destinationIndexPath.row -1]; // ignore "add new" row
            // update selector options
            self.rowDescriptor.selectorOptions = selectorOptions;
            // callback
            [self.rowDescriptor optionsViewControllerDidSortSelectorOption:sourceCellObject fromPosition:(int)sourceIndexPath.row toPosition:(int)destinationIndexPath.row];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        return self.editing ? [[self selectorOptions] count] + 1 : [[self selectorOptions] count];
    }
    return [[self selectorOptions] count];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        return indexPath.row > 0 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        if (editingStyle == UITableViewCellEditingStyleInsert) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.editingOptionsAddNewOptionTitle
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            // add textfield showing old option text
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.keyboardType = UIKeyboardTypeAlphabet;
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                textField.placeholder = @"Enter text";
            }];
            
            // ok action performs change of option text
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 UITextField *textField = [alert.textFields firstObject];
                                                                 if (![textField.text isEqualToString:@""]) {
                                                                     NSLog(@"option text changed to %@", textField.text);
                                                                     
                                                                     // create new option with new text
                                                                     id newOption = [XLFormOptionsObject formOptionsObjectWithValue:@(-1) displayText:textField.text];
                                                                     
                                                                     // replace option at the bottom
                                                                     NSMutableArray *selectorOptions = [[self selectorOptions] mutableCopy];
                                                                     [selectorOptions addObject:newOption];
                                                                     
                                                                     // change row selector options
                                                                     self.rowDescriptor.selectorOptions = selectorOptions;
                                                                     
                                                                     // callback
                                                                     [self.rowDescriptor optionsViewControllerDidAddSelectorOption:newOption];
                                                                     
                                                                     // reload table
                                                                     [self.tableView reloadData];
                                                                 }
                                                             }];
            [alert addAction:okAction];
            
            // cancel action does nothing
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
            [alert addAction:cancelAction];
            
            // show alert
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (editingStyle == UITableViewCellEditingStyleDelete) {
            // retrieve selector options
            NSMutableArray *selectorOptions = [[self selectorOptions] mutableCopy];
            
            if ([selectorOptions count] > 1) {
                id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row - 1]; // ignore "add new" row
                
                // move selector option from source to destination row
                [selectorOptions removeObjectAtIndex:indexPath.row - 1];
                
                // update selector options
                self.rowDescriptor.selectorOptions = selectorOptions;
                
                // callback
                [self.rowDescriptor optionsViewControllerDidDeleteSelectorOption:cellObject];
                
                // reload table
                [self.tableView reloadData];
                
            } else {
                // avoid deleting last selector option
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                               message:@"Can't delete last option. Add another option and then try again."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                // ok action does nothing
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                [alert addAction:okAction];
                
                // show alert
                [self presentViewController:alert animated:YES completion:nil];
                
                // reload table
                [self.tableView reloadData];
            }
            
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        // not handled yet
    } else {
        return proposedDestinationIndexPath;
    }
    return proposedDestinationIndexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        // avoid editing "add new" row
        return indexPath.row == 0 ? nil : indexPath;
    }
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRightDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    
    if (self.editing) {
        
        NSAssert(self.rowDescriptor.rowType != XLFormRowDescriptorTypeSelectorLeftRight, @"Editing selector options is currently not allowed for XLFormRowDescriptorTypeSelectorLeftRight row types.");
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Add new";
            cell.editingAccessoryType = UITableViewCellAccessoryNone;
        } else {
            id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row - 1];
            cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];
        cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]){
            cell.accessoryType = ([self selectedValuesContainsOption:cellObject] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        }
        else {
            if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        cell.editingAccessoryType = UITableViewCellAccessoryNone;

    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.titleFooterSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleHeaderSection;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.editing) {
        
        NSAssert(self.rowDescriptor.rowType != XLFormRowDescriptorTypeSelectorLeftRight, @"Editing selector options is currently not allowed for XLFormRowDescriptorTypeSelectorLeftRight row types.");
        
        id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row - 1]; // ignore "add new" row
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.editingOptionsNewTextForOptionTitle
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        // add textfield showing old option text
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeAlphabet;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.text = [cellObject displayText];
            textField.placeholder = @"Enter text";
        }];
        
        // ok action performs change of option text
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *textField = [alert.textFields firstObject];
                                                             if (![textField.text isEqualToString:@""]) {
                                                                 NSLog(@"option text changed to %@", textField.text);
                                                                 
                                                                 // create new option with new text
                                                                 id newOption = [XLFormOptionsObject formOptionsObjectWithValue:[cellObject valueData] displayText:textField.text];
                                                                 
                                                                 // replace option
                                                                 NSMutableArray *selectorOptions = [[self selectorOptions] mutableCopy];
                                                                 [selectorOptions replaceObjectAtIndex:indexPath.row-1 withObject:newOption];
                                                                 
                                                                 // change row selector options
                                                                 self.rowDescriptor.selectorOptions = selectorOptions;
                                                                 
                                                                 // reload table
                                                                 [self.tableView reloadData];
                                                                 
                                                                 // callback
                                                                 [self.rowDescriptor optionsViewControllerDidChangeSelectorOption:cellObject newText:textField.text];
                                                             }
                                                         }];
        [alert addAction:okAction];
        
        // cancel action does nothing
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alert addAction:cancelAction];
        
        // show alert
        [self presentViewController:alert animated:YES completion:nil];

        
    } else {
        
        id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];

        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]){
            if ([self selectedValuesContainsOption:cellObject]){
                self.rowDescriptor.value = [self selectedValuesRemoveOption:cellObject];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else{
                self.rowDescriptor.value = [self selectedValuesAddOption:cellObject];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else{
            if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]){
                if (!self.rowDescriptor.required){
                    self.rowDescriptor.value = nil;
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else{
                if (self.rowDescriptor.value){
                    NSInteger index = [[self selectorOptions] formIndexForItem:self.rowDescriptor.value];
                    if (index != NSNotFound){
                        NSIndexPath * oldSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldSelectedIndexPath];
                        oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
                    }
                }
                self.rowDescriptor.value = cellObject;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            if (self.popoverController){
                [self.popoverController dismissPopoverAnimated:YES];
                [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
            }
            else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

-(NSMutableArray *)selectedValues
{
    if (self.rowDescriptor.value == nil){
        return [NSMutableArray array];
    }
    NSAssert([self.rowDescriptor.value isKindOfClass:[NSArray class]], @"XLFormRowDescriptor value must be NSMutableArray");
    return [NSMutableArray arrayWithArray:self.rowDescriptor.value];
}

-(BOOL)selectedValuesContainsOption:(id)option
{
    return ([self.selectedValues formIndexForItem:option] != NSNotFound);
}

-(NSMutableArray *)selectedValuesRemoveOption:(id)option
{
    for (id selectedValueItem in self.selectedValues) {
        if ([[selectedValueItem valueData] isEqual:[option valueData]]){
            NSMutableArray * result = self.selectedValues;
            [result removeObject:selectedValueItem];
            return result;
        }
    }
    return self.selectedValues;
}

-(NSMutableArray *)selectedValuesAddOption:(id)option
{
    NSAssert([self.selectedValues formIndexForItem:option] == NSNotFound, @"XLFormRowDescriptor value must not contain the option");
    NSMutableArray * result = self.selectedValues;
    [result addObject:option];
    return result;
}



-(NSString *)valueDisplayTextForOption:(id)option
{
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * transformedValue = [valueTransformer transformedValue:option];
        if (transformedValue){
            return transformedValue;
        }
    }
    return [option displayText];
}

-(NSArray *)selectorOptions
{
    if (self.rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorLeftRight){
        XLFormLeftRightSelectorOption * option = [self leftOptionForOption:self.rowDescriptor.leftRightSelectorLeftOptionSelected];
        return option.rightOptions;
    }
    else{
        return self.rowDescriptor.selectorOptions;
    }
}

-(XLFormLeftRightSelectorOption *)leftOptionForOption:(id)option
{
    return [[self.rowDescriptor.selectorOptions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * __unused bindings) {
        XLFormLeftRightSelectorOption * evaluatedLeftOption = (XLFormLeftRightSelectorOption *)evaluatedObject;
        return [evaluatedLeftOption.leftValue isEqual:option];
    }]] firstObject];
}


@end
