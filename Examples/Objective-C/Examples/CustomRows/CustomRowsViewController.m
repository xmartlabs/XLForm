//
//  CustomRowsViewController.m
//  XLForm
//
//  Created by Gaston Borba on 3/11/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "CustomRowsViewController.h"
#import "XLForm.h"
#import "XLFormWeekDaysCell.h"
#import "XLFormRatingCell.h"

static NSString * const XLFormRowDescriptorTypeWeekDays = @"XLFormRowDescriptorTypeWeekDays";
static NSString * const XLFormRowDescriptorTypeRate = @"XLFormRowDescriptorTypeRate";

@implementation CustomRowsViewController

-(id)init
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormWeekDaysCell class]) forKey:XLFormRowDescriptorTypeWeekDays];
    
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:NSStringFromClass([XLFormRatingCell class]) forKey:XLFormRowDescriptorTypeRate];
    
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
                   kMonday: @(NO),
                   kTuesday: @(NO),
                   kWednesday: @(NO),
                   kThursday: @(NO),
                   kFriday: @(NO),
                   kSaturday: @(NO)
                   };
    [section addFormRow:row];
    
    self.form = form;
}




@end
