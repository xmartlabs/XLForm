//
//  OthersFormViewController.m
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

#import "OthersFormViewController.h"
#import "XLFormCustomCell.h"

NSString *const kSwitchBool = @"switchBool";
NSString *const kSwitchCheck = @"switchBool";
NSString *const kStepCounter = @"stepCounter";
NSString *const kSlider = @"slider";
NSString *const kSegmentedControl = @"segmentedControl";
NSString *const kCustom = @"custom";
NSString *const kInfo = @"info";
NSString *const kButton = @"button";

@implementation OthersFormViewController

- (id)init
{
    self = [super init];
    if (self){
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm
{
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Other Cells"];
    XLFormSectionDescriptor * section;
    
    // Basic Information
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Other Cells"];
    section.footerTitle = @"OthersFormViewController.h";
    [form addFormSection:section];
    
    // Switch
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Switch"];
    row.disabled = YES;
    row.value = @YES;
    [section addFormRow:row];
    
    // check
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchCheck rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Check"]];

    // step counter
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kStepCounter rowType:XLFormRowDescriptorTypeStepCounter title:@"Step counter"];
    row.disabled = NO;
    [section addFormRow:row];
    
    // Segmented Control
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSegmentedControl rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Fruits"];
    row.selectorOptions = @[@"Apple", @"Orange", @"Pear"];
    row.value = @"Pear";
    [section addFormRow:row];
	
	
    // Slider
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSlider rowType:XLFormRowDescriptorTypeSlider title:@"Slider"];
    row.value = @(30);
    [row.cellConfigAtConfigure setObject:@(100) forKey:@"slider.maximumValue"];
    [row.cellConfigAtConfigure setObject:@(10) forKey:@"slider.minimumValue"];
    [row.cellConfigAtConfigure setObject:@(4) forKey:@"steps"];
    [section addFormRow:row];
    
    // Custom cell
    XLFormRowDescriptor *customRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kCustom rowType:@"XLFormRowDescriptorTypeCustom"];
    // Must set custom cell or add custom cell to cellClassesForRowDescriptorTypes dictionary before XLFormViewController loaded
    customRowDescriptor.cellClass = [XLFormCustomCell class];
    [section addFormRow:customRowDescriptor];
    
    // Info cell
    XLFormRowDescriptor *infoRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kInfo rowType:XLFormRowDescriptorTypeInfo];
    infoRowDescriptor.title = @"Version";
    infoRowDescriptor.value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [section addFormRow:infoRowDescriptor];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Buttons"];
    section.footerTitle = @"Button will show a message when Switch is ON";
    [form addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"Button"];
    [buttonRow.cellConfig setObject:self.view.tintColor forKey:@"textLabel.textColor"];
    [section addFormRow:buttonRow];

    self.form = form;
}


-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    [super didSelectFormRow:formRow];
    
    if ([formRow.tag isEqual:kButton]){
        if ([[self.form formRowWithTag:kSwitchBool].value boolValue]){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Switch is ON", nil) message:@"Button has checked the switch value..." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
        [self deselectFormRow:formRow];
    }
}

@end
