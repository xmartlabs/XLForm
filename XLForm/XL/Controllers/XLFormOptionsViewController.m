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

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self){
        _titleFooterSection = nil;
        _titleHeaderSection = nil;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style titleHeaderSection:(NSString *)titleHeaderSection titleFooterSection:(NSString *)titleFooterSection
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self selectorOptions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRightDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    id cellObject =  [[self selectorOptions] objectAtIndex:indexPath.row];

    [self.rowDescriptor.cellConfigForSelector enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
    
    cell.textLabel.text = [self valueDisplayTextForOption:cellObject];
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]){
        cell.accessoryType = ([self selectedValuesContainsOption:cellObject] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    }
    else{
        if ([[self.rowDescriptor.value valueData] isEqual:[cellObject valueData]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
				cell.accessoryType = UITableViewCellAccessoryNone;
            }
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
        if (self.modalPresentationStyle == UIModalPresentationPopover){
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper

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

#pragma mark - Helpers

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
