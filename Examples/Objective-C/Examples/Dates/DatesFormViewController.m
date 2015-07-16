//
//  DatesFormViewController.m
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

NSString *const kDateInline = @"dateInline";
NSString *const kTimeInline = @"timeInline";
NSString *const kDateTimeInline = @"dateTimeInline";

NSString *const kDate = @"date";
NSString *const kTime = @"time";
NSString *const kDateTime = @"dateTime";

#import "DatesFormViewController.h"


@implementation DatesFormViewController


- (id)init
{
    self = [super init];
    if (self){
        XLFormDescriptor * form;
        XLFormSectionDescriptor * section;
        XLFormRowDescriptor * row;
        
        form = [XLFormDescriptor formDescriptorWithTitle:@"Dates"];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Inline Dates"];
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateInline rowType:XLFormRowDescriptorTypeDateInline title:@"Date"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // DateTime
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kTimeInline rowType:XLFormRowDescriptorTypeTimeInline title:@"Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // Time
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateTimeInline rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Date Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Dates"];
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeDate title:@"Date"];
        row.value = [NSDate new];
        [row.cellConfigAtConfigure setObject:[NSDate new] forKey:@"minimumDate"];
        [row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
        [section addFormRow:row];
        
        // DateTime
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kTime rowType:XLFormRowDescriptorTypeTime title:@"Time"];
        [row.cellConfigAtConfigure setObject:@(10) forKey:@"minuteInterval"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // Time
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateTime rowType:XLFormRowDescriptorTypeDateTime title:@"Date Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Disabled Dates"];
        section.footerTitle = @"DatesFormViewController.h";
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeDate title:@"Date"];
        row.disabled = YES;
        row.required = YES;
        row.value = [NSDate new];
        [section addFormRow:row];
        
        self.form = form;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"Disable" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(disableEnable:)];
    barButton.possibleTitles = [NSSet setWithObjects:@"Disable", @"Enable", nil];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)disableEnable:(UIBarButtonItem *)button
{
    self.form.disabled = !self.form.disabled;
    [button setTitle:(self.form.disabled ? @"Enable" : @"Disable")];
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
}


@end
