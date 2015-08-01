//
//  AccessoryViewFormViewController.m
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
#import "AccessoryViewFormViewController.h"

//This macro defines if we use predicates to hide rows or do it manually the old way.
//Just comment out if you want it to run without predicates.
#define USE_PREDICATES_FOR_HIDING

@interface AccessoryViewFormViewController ()

@end

@implementation AccessoryViewFormViewController
{
#ifndef USE_PREDICATES_FOR_HIDING
    XLFormRowDescriptor * _rowShowAccessoryView;
    XLFormRowDescriptor * _rowStopDisableRow;
    XLFormRowDescriptor * _rowStopInlineRow;
    XLFormRowDescriptor * _rowSkipCanNotBecomeFirstResponderRow;
#endif
}


NSString * kAccessoryViewRowNavigationEnabled               = @"kRowNavigationEnabled";
NSString * kAccessoryViewRowNavigationShowAccessoryView     = @"kRowNavigationShowAccessoryView";
NSString * kAccessoryViewRowNavigationStopDisableRow        = @"rowNavigationStopDisableRow";
NSString * kAccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow = @"rowNavigationSkipCanNotBecomeFirstResponderRow";
NSString * kAccessoryViewRowNavigationStopInlineRow = @"rowNavigationStopInlineRow";
NSString * kAccessoryViewName = @"name";
NSString * kAccessoryViewEmail = @"email";
NSString * kAccessoryViewTwitter = @"twitter";
NSString * kAccessoryViewUrl = @"url";
NSString * kAccessoryViewDate = @"date";
NSString * kAccessoryViewTextView = @"textView";
NSString * kAccessoryViewCheck = @"check";
NSString * kAccessoryViewNotes = @"notes";




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
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Accessory View"];
    formDescriptor.rowNavigationOptions = XLFormRowNavigationOptionEnabled;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * switchRow;
    
    // Configuration section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Row Navigation Settings"];
    section.footerTitle = @"Changing the Settings values you will navigate differently";
    [formDescriptor addFormSection:section];
    
    // RowNavigationEnabled
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewRowNavigationEnabled rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Row Navigation Enabled?"];
    switchRow.value = @YES;
    [section addFormRow:switchRow];
    
    // RowNavigationShowAccessoryView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewRowNavigationShowAccessoryView rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Show input accessory row?"];
    row.value = @((formDescriptor.rowNavigationOptions & XLFormRowNavigationOptionEnabled) == XLFormRowNavigationOptionEnabled);
    [section addFormRow:row];
#ifdef USE_PREDICATES_FOR_HIDING
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
#else
    _rowShowAccessoryView = row;
#endif
    
    // RowNavigationStopDisableRow
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewRowNavigationStopDisableRow rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Stop when reach disabled row?"];
    row.value = @((formDescriptor.rowNavigationOptions & XLFormRowNavigationOptionStopDisableRow) == XLFormRowNavigationOptionStopDisableRow);
    [section addFormRow:row];
#ifdef USE_PREDICATES_FOR_HIDING
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
#else
    _rowStopDisableRow = row;
#endif
    
    // RowNavigationStopInlineRow
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewRowNavigationStopInlineRow rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Stop when reach inline row?"];
    row.value = @((formDescriptor.rowNavigationOptions & XLFormRowNavigationOptionStopInlineRow) == XLFormRowNavigationOptionStopInlineRow);
    [section addFormRow:row];
#ifdef USE_PREDICATES_FOR_HIDING
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
#else
    _rowStopInlineRow = row;
#endif
    
    // RowNavigationSkipCanNotBecomeFirstResponderRow
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Skip Can Not Become First Responder Row?"];
    row.value = @((formDescriptor.rowNavigationOptions & XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) == XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow);
    [section addFormRow:row];
#ifdef USE_PREDICATES_FOR_HIDING
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
#else
    _rowSkipCanNotBecomeFirstResponderRow = row;
#endif
    

    
    // Basic Information - Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewName rowType:XLFormRowDescriptorTypeText title:@"Name"];
    row.required = YES;
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewEmail rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    // validate the email
    [row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    // Twitter
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewTwitter rowType:XLFormRowDescriptorTypeTwitter title:@"Twitter"];
    row.disabled = @YES;
    row.value = @"@no_editable";
    [section addFormRow:row];
    
    // Url
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewUrl rowType:XLFormRowDescriptorTypeURL title:@"Url"];
    [section addFormRow:row];
    
    // Url
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewDate rowType:XLFormRowDescriptorTypeDateInline title:@"Date Inline"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewTextView rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"TEXT VIEW EXAMPLE" forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewCheck rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Check"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAccessoryViewNotes rowType:XLFormRowDescriptorTypeTextView title:@"Notes"];
    [section addFormRow:row];
    
    self.form = formDescriptor;
}



#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
#ifndef USE_PREDICATES_FOR_HIDING
    NSString * kRowNavigationEnabled        = @"kRowNavigationEnabled";
    if ([rowDescriptor.tag isEqualToString:kRowNavigationEnabled]){
        if ([[rowDescriptor.value valueData] isEqual:@NO]){
            self.form.rowNavigationOptions = XLFormRowNavigationOptionNone;
            [self.form removeFormRowWithTag:kAccessoryViewRowNavigationShowAccessoryView];
            [self.form removeFormRowWithTag:kAccessoryViewRowNavigationStopDisableRow];
            [self.form removeFormRowWithTag:kAccessoryViewRowNavigationStopInlineRow];
            [self.form removeFormRowWithTag:kAccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow];
        }
        else{
            self.form.rowNavigationOptions = XLFormRowNavigationOptionEnabled;
            _rowShowAccessoryView.value = @YES;
            _rowStopDisableRow.value = @NO;
            _rowStopInlineRow.value = @NO;
            _rowSkipCanNotBecomeFirstResponderRow.value = @NO;
            [self.form addFormRow:_rowShowAccessoryView afterRow:rowDescriptor];
            [self.form addFormRow:_rowStopDisableRow afterRow:_rowShowAccessoryView];
            [self.form addFormRow:_rowStopInlineRow afterRow:_rowStopDisableRow];
            [self.form addFormRow:_rowSkipCanNotBecomeFirstResponderRow afterRow:_rowStopInlineRow];
            
        }
    }
    else
#endif
    if ([rowDescriptor.tag isEqualToString:kAccessoryViewRowNavigationStopDisableRow]){
        if ([[rowDescriptor.value valueData] isEqual:@(YES)]){
            self.form.rowNavigationOptions = self.form.rowNavigationOptions | XLFormRowNavigationOptionStopDisableRow;
        }
        else{
            self.form.rowNavigationOptions = self.form.rowNavigationOptions & (~XLFormRowNavigationOptionStopDisableRow);
        }
    }
    else if ([rowDescriptor.tag isEqualToString:kAccessoryViewRowNavigationStopInlineRow]){
        if ([[rowDescriptor.value valueData] isEqual:@(YES)]){
            self.form.rowNavigationOptions = self.form.rowNavigationOptions | XLFormRowNavigationOptionStopInlineRow;
        }
        else{
            self.form.rowNavigationOptions = self.form.rowNavigationOptions & (~XLFormRowNavigationOptionStopInlineRow);
        }
    }
    else if ([rowDescriptor.tag isEqualToString:kAccessoryViewRowNavigationSkipCanNotBecomeFirstResponderRow]){
        if ([[rowDescriptor.value valueData] isEqual:@(YES)]){
            self.form.rowNavigationOptions = self.form.rowNavigationOptions | XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow;
        }
        else{
            self.form.rowNavigationOptions = self.form.rowNavigationOptions & (~XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow);
        }
    }
}

-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    if ([[[self.form formRowWithTag:kAccessoryViewRowNavigationShowAccessoryView].value valueData] isEqual:@NO]){
        return nil;
    }
    return [super inputAccessoryViewForRowDescriptor:rowDescriptor];
}

@end
