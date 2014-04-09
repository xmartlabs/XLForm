//
//  XLFormSelectorTableViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Created by Martin Barreto on 31/3/14.
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
#import "XLFormRightDetailCell.h"
#import "XLFormSelectorTableViewController.h"

@interface XLFormSelectorTableViewController () <XLSelectorTableViewControllerProtocol>

@end

@implementation XLFormSelectorTableViewController

static NSString * kCellIdentifier = @"CellIdentifier";

-(id)initWithDelegate:(id<XLFormOptionsViewControllerDelegate>)delegate localDataLoader:(XLLocalDataLoader *)localDataLoader remoteDataLoader:(XLRemoteDataLoader *)remoteDataLoader
{
    self = [super init];
    if (self){
        _selectorDelegate = delegate;
        self.localDataLoader = localDataLoader;
        self.remoteDataLoader = remoteDataLoader;
        self.supportRefreshControl = NO;
        self.loadingPagingEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[XLFormRightDetailCell class] forCellReuseIdentifier:kCellIdentifier];
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if([self.selectorDelegate respondsToSelector:@selector(optionsViewController:didSelectOption:atIndex:)]) {
        NSManagedObject * managedObject = [self.localDataLoader objectAtIndexPath:indexPath];
        [self.selectorDelegate optionsViewController:self didSelectOption:managedObject atIndex:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([self.selectorDelegate respondsToSelector:@selector(optionsViewController:didDeselectOption:atIndex:)]){
        NSManagedObject * managedObject = [self.localDataLoader objectAtIndexPath:indexPath];
        [self.selectorDelegate optionsViewController:self didDeselectOption:managedObject atIndex:indexPath];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject * managedObject = [self.localDataLoader objectAtIndexPath:indexPath];
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [managedObject displayText];
    if (self.selectorDelegate && [self.selectorDelegate respondsToSelector:@selector(optionsViewControllerOptions:isOptionSelected:)]){
        if ([self.selectorDelegate optionsViewControllerOptions:self isOptionSelected:managedObject]){
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

@end
