//  CustomRowsViewController.m
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

#import "CustomRowsViewController.h"
#import "XLForm.h"
#import "XLFormWeekDaysCell.h"
#import "XLFormRatingCell.h"
#import "FloatLabeledTextFieldCell.h"
#import "XLFormCustomCell.h"
#import "XLFormInlineSegmentedCell.h"

static NSString * const kCustomRowFirstRatingTag = @"CustomRowFirstRatingTag";
static NSString * const kCustomRowSecondRatingTag = @"CustomRowSecondRatingTag";
static NSString * const kCustomRowFloatLabeledTextFieldTag = @"CustomRowFloatLabeledTextFieldTag";
static NSString * const kCustomRowWeekdays = @"CustomRowWeekdays";
static NSString * const kCustomInline = @"kCustomInline";
static NSString * const kCustomRowText = @"kCustomText";

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
    
    // Section Ratings
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Ratings"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowFirstRatingTag rowType:XLFormRowDescriptorTypeRate title:@"First Rating"];
    row.value = @(3);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowSecondRatingTag rowType:XLFormRowDescriptorTypeRate title:@"Second Rating"];
    row.value = @(1);
    [section addFormRow:row];
    
    // Section Float Labeled Text Field
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Float Labeled Text Field"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowFloatLabeledTextFieldTag rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Title"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowFloatLabeledTextFieldTag rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"First Name"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowFloatLabeledTextFieldTag rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Last Name"];
    [section addFormRow:row];
    
    // Section Weekdays
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Weekdays"];
    [form addFormSection:section];
    
    // WeekDays
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowWeekdays rowType:XLFormRowDescriptorTypeWeekDays];
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
    
    // Custom Inline Segmented row
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Custom Inline"];
    [form addFormSection:section];
    
    // Inline segmented
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomInline rowType:XLFormRowDescriptorTypeSegmentedInline];
    row.title = @"You support...";
    row.selectorOptions = @[@"Uruguay", @"Brazil", @"Argentina", @"Chile"];
    row.value = @"Uruguay";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    XLFormRowDescriptor *customRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomRowText rowType:@"XLFormRowDescriptorTypeCustom"];
    // Must set custom cell or add custom cell to cellClassesForRowDescriptorTypes dictionary before XLFormViewController loaded
    customRowDescriptor.cellClass = [XLFormCustomCell class];
    [section addFormRow:customRowDescriptor];
    
    self.form = form;
}

@end
