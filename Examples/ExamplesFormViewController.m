//
//  ExamplesFormViewController.m
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

#import "InputsFormViewController.h"
#import "SelectorsFormViewController.h"
#import "OthersFormViewController.h"
#import "DatesFormViewController.h"
#import "MultiValuedFormViewController.h"
#import "ExamplesFormViewController.h"
#import "NativeEventFormViewController.h"
#import "UICustomizationFormViewController.h"

NSString * const kTextFieldAndTextView = @"TextFieldAndTextView";
NSString * const kSelectors = @"Selectors";
NSString * const kOthes = @"Others";
NSString * const kDates = @"Dates";
NSString * const kMultivalued = @"Multivalued";

@interface ExamplesFormViewController ()

@end

@implementation ExamplesFormViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

#pragma mark - Helper

-(void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Real examples"];
    [form addFormSection:section];
    
    // NativeEventFormViewController
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"realExamples" rowType:XLFormRowDescriptorTypeButton title:@"iOS Calendar Event Form"];
    row.buttonViewController = [NativeEventNavigationViewController class];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"This form is actually an example"];
    section.footerTitle = @"ExamplesFormViewController.h, Select an option to view another example";
    [form addFormSection:section];
    
    
    // TextFieldAndTextView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTextFieldAndTextView rowType:XLFormRowDescriptorTypeButton title:@"Text Fields"];
    row.buttonViewController = [InputsFormViewController class];
    [section addFormRow:row];
    
    // Selectors
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectors rowType:XLFormRowDescriptorTypeButton title:@"Selectors"];
    row.buttonViewController = [SelectorsFormViewController class];
    [section addFormRow:row];
    
    // Dates
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDates rowType:XLFormRowDescriptorTypeButton title:@"Dates"];
    row.buttonViewController = [DatesFormViewController class];
    [section addFormRow:row];
    
    // Others
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kOthes rowType:XLFormRowDescriptorTypeButton title:@"Other Rows"];
    row.buttonViewController = [OthersFormViewController class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multivalued example"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"MultiValued Sections"];
    row.buttonViewController = [MultiValuedFormViewController class];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"UI Customization"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"UI Customization"];
    row.buttonViewController = [UICustomizationFormViewController class];
    [section addFormRow:row];
    
    
    self.form = form;

}



@end
