//  CustomRowsViewController.m
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

#import "CustomRowsViewController.h"
#import "XLForm.h"
#import "XLFormWeekDaysCell.h"
#import "XLFormRatingCell.h"

@implementation CustomRowsViewController

-(id)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Custom Rows"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Ratings"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Rate1" rowType:XLFormRowDescriptorTypeRate title:@"First Rating"];
    row.value = @(3);
    [section addFormRow:row];
    
    // Rate
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Rate2" rowType:XLFormRowDescriptorTypeRate title:@"Second Rating"];
    row.value = @(1);
    [section addFormRow:row];
    
    // Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Weekdays"];
    [form addFormSection:section];
    
    // WeekDays
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"WeekDays" rowType:XLFormRowDescriptorTypeWeekDays];
    row.value =  @{
                   kSunday: @(NO),
                   kMonday: @(YES),
                   kTuesday: @(YES),
                   kWednesday: @(NO),
                   kThursday: @(NO),
                   kFriday: @(NO),
                   kSaturday: @(NO)
                   };
    [section addFormRow:row];
    
    self.form = form;
}

@end
