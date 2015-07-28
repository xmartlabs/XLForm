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
NSString *const kCountDownTimerInline = @"countDownTimerInline";
NSString *const kDatePicker = @"datePicker";
NSString *const kDate = @"date";
NSString *const kTime = @"time";
NSString *const kDateTime = @"dateTime";
NSString *const kCountDownTimer = @"countDownTimer";

#import "DatesFormViewController.h"
@interface DatesFormViewController() <XLFormDescriptorDelegate>
@end

@implementation DatesFormViewController


- (id)init
{
    self = [super init];
    if (self){
        XLFormDescriptor * form;
        XLFormSectionDescriptor * section;
        
        XLFormRowDescriptor * row;
        
        form = [XLFormDescriptor formDescriptorWithTitle:@"Date & Time"];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Inline Dates"];
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateInline rowType:XLFormRowDescriptorTypeDateInline title:@"Date"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // Time
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kTimeInline rowType:XLFormRowDescriptorTypeTimeInline title:@"Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // DateTime
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateTimeInline rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Date Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // CountDownTimer
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kCountDownTimerInline rowType:XLFormRowDescriptorTypeCountDownTimerInline title:@"Countdown Timer"];
        NSDateComponents * dateComp = [NSDateComponents new];
        dateComp.hour = 0;
        dateComp.minute = 7;
        dateComp.timeZone = [NSTimeZone systemTimeZone];
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        row.value = [calendar dateFromComponents:dateComp];
        [section addFormRow:row];
        
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Dates"];
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeDate title:@"Date"];
        row.value = [NSDate new];
        [row.cellConfigAtConfigure setObject:[NSDate new] forKey:@"minimumDate"];
        [row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
        [section addFormRow:row];
        
        // Time
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kTime rowType:XLFormRowDescriptorTypeTime title:@"Time"];
        [row.cellConfigAtConfigure setObject:@(10) forKey:@"minuteInterval"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // DateTime
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDateTime rowType:XLFormRowDescriptorTypeDateTime title:@"Date Time"];
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // CountDownTimer
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kCountDownTimerInline rowType:XLFormRowDescriptorTypeCountDownTimer title:@"Countdown Timer"];
        row.value = [calendar dateFromComponents:dateComp];
        [section addFormRow:row];
        
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Disabled Dates"];
        //section.footerTitle = @"DatesFormViewController.h";
        [form addFormSection:section];
        
        // Date
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeDate title:@"Date"];
        row.disabled = @YES;
        row.required = YES;
        row.value = [NSDate new];
        [section addFormRow:row];
        
        // DatePicker
        section = [XLFormSectionDescriptor formSectionWithTitle:@"DatePicker"];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kDatePicker rowType:XLFormRowDescriptorTypeDatePicker];
        [row.cellConfigAtConfigure setObject:@(UIDatePickerModeDate) forKey:@"datePicker.datePickerMode"];
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

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    // super implementation must be called
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    if([formRow.tag isEqualToString:kDatePicker])
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"DatePicker"
                                                          message:@"Value Has changed!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
#else
        if ([UIAlertController class]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"DatePicker"
                                                                                      message:@"Value Has changed!"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"DatePicker"
                                                              message:@"Value Has changed!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
#endif
    }
}


@end
