//
//  FormattersViewController.m
//  XLForm
//
//  Created by Freddy Henin on 12/29/14.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "XLForm.h"

#import "FormattersViewController.h"

#import <SHSPhoneComponent/SHSPhoneNumberFormatter+UserConfig.h>


// Simple little class to demonstraite currency formatting.   Unfortunally we have to subclass
// NSNumberFormatter to work aroundn some long known rounding bugs with NSNumberFormatter
//     http://stackoverflow.com/questions/12580162/nsstring-to-nsdate-conversion-issue
@interface CurrencyFormatter : NSNumberFormatter

@property (readonly) NSDecimalNumberHandler *roundingBehavior;

@end

@implementation CurrencyFormatter

- (id) init
{
    self = [super init];
    if (self) {
        [self setNumberStyle: NSNumberFormatterCurrencyStyle];
        [self setGeneratesDecimalNumbers:YES];
        
        NSUInteger currencyScale = [self maximumFractionDigits];
        
        _roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:currencyScale raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
        
    }
    
    return self;
}

//- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
//{
//    NSDecimalNumber *number;
//    BOOL success = [super getObjectValue:&number forString:string errorDescription:error];
//    
//    if (success) {
//        *anObject = [number decimalNumberByRoundingAccordingToBehavior:_roundingBehavior];
//    }
//    else {
//        *anObject = nil;
//    }
//    
//    return success;
//}

@end

@interface FormattersViewController ()
@end

@implementation FormattersViewController

-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    formDescriptor.assignFirstResponderOnShow = NO;
    
    section = [XLFormSectionDescriptor formSection];
    section.title = @"NSFormatter Support";
    section.footerTitle = @"Rows can be configured to use the formatter as you type or to toggle on and off during for display/editing.  You will most likely need custom NSFormatter objects to do on the fly formatting since NSNumberFormatter is pretty limited in this regard.";
    [formDescriptor addFormSection:section];
    
    // Phone
    SHSPhoneNumberFormatter *formatter = [[SHSPhoneNumberFormatter alloc] init];
    [formatter setDefaultOutputPattern:@"(###) ###-####" imagePath:nil];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phone" rowType:XLFormRowDescriptorTypePhone title:@"US Phone"];
    row.valueFormatter = formatter;
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    
    row.useValueFormatterDuringInput = YES;
    [section addFormRow:row];
    
    // Currency
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"currency" rowType:XLFormRowDescriptorTypeDecimal title:@"USD"];
    CurrencyFormatter *numberFormatter = [[CurrencyFormatter alloc] init];
    row.valueFormatter = numberFormatter;
    row.value = [NSDecimalNumber numberWithDouble:9.95];
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    // Accounting
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"percent" rowType:XLFormRowDescriptorTypeNumber title:@"Test Score"];
    NSNumberFormatter *acctFormatter = [[NSNumberFormatter alloc] init];
    [acctFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    row.valueFormatter = acctFormatter;
    row.value = @(0.75);
    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    return [super initWithForm:formDescriptor];
    
}

@end