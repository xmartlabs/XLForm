//
//  XLFormOptionsViewController.m
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

#import "NSObject+XLFormAdditions.h"
#import "XLFormOptionsViewController.h"
#import "XLFormRightDetailCell.h"

#define CELL_REUSE_IDENTIFIER  @"OptionCell"

@interface XLFormOptionsViewController () <UITableViewDataSource>

@property NSArray * options;
@property BOOL isMultipleSelection;
@property NSString * titleHeaderSection;
@property NSString * titleFooterSection;

@end

@implementation XLFormOptionsViewController

@synthesize options = _options;
@synthesize isMultipleSelection = _isMultipleSelection;
@synthesize titleHeaderSection = _titleHeaderSection;
@synthesize titleFooterSection = _titleFooterSection;
@synthesize rowDescriptor = _rowDescriptor;

- (id)initWithOptions:(NSArray *)options multipleSelection:(BOOL)multipleSelection style:(UITableViewStyle)style
{
    return [self initWithOptions:options multipleSelection:multipleSelection style:style titleHeaderSection:nil titleFooterSection:nil];
}

- (id)initWithOptions:(NSArray *)options multipleSelection:(BOOL)multipleSelection
                style:(UITableViewStyle)style
   titleHeaderSection:(NSString *)titleHeaderSection
   titleFooterSection:(NSString *)titleFooterSection;
{
    self = [super initWithStyle:style];
    if (self) {
        _options = options;
        _isMultipleSelection = multipleSelection;
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
    [self.tableView setAllowsMultipleSelection:self.isMultipleSelection];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRightDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = [[self.options objectAtIndex:indexPath.row] displayText];
    if ([[self.rowDescriptor.value formValue] isEqual:[[self.options objectAtIndex:indexPath.row] formValue]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.rowDescriptor.value = [self.options objectAtIndex:indexPath.row];
    // add indexSet item
//    NSMutableIndexSet * mutableIndexSet = [self.selectedIndexSet mutableCopy];
//    [mutableIndexSet addIndex:indexPath.row];
//    self.selectedIndexSet = mutableIndexSet;
//    if([self.delegate respondsToSelector:@selector(optionsViewController:didSelectOption:atIndex:)]) {
//        [self.delegate optionsViewController:self didSelectOption:[self.options objectAtIndex:indexPath.row] atIndex:indexPath];
//    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // remove indexSet item
//    NSMutableIndexSet * mutableIndexSet = [self.selectedIndexSet mutableCopy];
//    [mutableIndexSet removeIndex:indexPath.row];
//    self.selectedIndexSet = mutableIndexSet;
//    if ([self.delegate respondsToSelector:@selector(optionsViewController:didDeselectOption:atIndex:)]){
//        [self.delegate optionsViewController:self didDeselectOption:[self.options objectAtIndex:indexPath.row] atIndex:indexPath];
//    }
}

@end
