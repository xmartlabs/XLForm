//
//  ExamplesFormViewController.m
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

#import "InputsFormViewController.h"
#import "SelectorsFormViewController.h"
#import "OthersFormViewController.h"
#import "DatesFormViewController.h"
#import "MultiValuedFormViewController.h"
#import "ExamplesFormViewController.h"
#import "NativeEventFormViewController.h"
#import "UICustomizationFormViewController.h"
#import "CustomRowsViewController.h"
#import "AccessoryViewFormViewController.h"
#import "PredicateFormViewController.h"
#import "FormattersViewController.h"

NSString * const kTextFieldAndTextView = @"TextFieldAndTextView";
NSString * const kSelectors = @"Selectors";
NSString * const kOthes = @"Others";
NSString * const kDates = @"Dates";
NSString * const kPredicates = @"BasicPredicates";
NSString * const kBlogExample = @"BlogPredicates";
NSString * const kMultivalued = @"Multivalued";
NSString * const kMultivaluedOnlyReorder = @"MultivaluedOnlyReorder";
NSString * const kMultivaluedOnlyInsert = @"MultivaluedOnlyInsert";
NSString * const kMultivaluedOnlyDelete = @"MultivaluedOnlyDelete";
NSString * const kValidations= @"Validations";
NSString * const kFormatters = @"Formatters";

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
    row.action.formSegueIdentifier = @"NativeEventNavigationViewControllerSegue";
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"This form is actually an example"];
    section.footerTitle = @"ExamplesFormViewController.h, Select an option to view another example";
    [form addFormSection:section];
    
    
    // TextFieldAndTextView
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kTextFieldAndTextView rowType:XLFormRowDescriptorTypeButton title:@"Text Fields"];
    row.action.viewControllerClass = [InputsFormViewController class];
    [section addFormRow:row];
    
    // Selectors
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectors rowType:XLFormRowDescriptorTypeButton title:@"Selectors"];
    row.action.formSegueIdentifier = @"SelectorsFormViewControllerSegue";
    [section addFormRow:row];
    
    // Dates
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDates rowType:XLFormRowDescriptorTypeButton title:@"Date & Time"];
    row.action.viewControllerClass = [DatesFormViewController class];
    [section addFormRow:row];
    
    // NSFormatters
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFormatters rowType:XLFormRowDescriptorTypeButton title:@"NSFormatter Support"];
    row.action.viewControllerClass = [FormattersViewController class];
    [section addFormRow:row];
    
    // Others
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kOthes rowType:XLFormRowDescriptorTypeButton title:@"Other Rows"];
    row.action.formSegueIdentifier = @"OthersFormViewControllerSegue";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multivalued example"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"Multivalued Sections"];
    row.action.viewControllerClass = [MultivaluedFormViewController class];
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivaluedOnlyReorder rowType:XLFormRowDescriptorTypeButton title:@"Multivalued Only Reorder"];
    row.action.viewControllerClass = [MultivaluedOnlyReorderViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivaluedOnlyInsert rowType:XLFormRowDescriptorTypeButton title:@"Multivalued Only Insert"];
    row.action.viewControllerClass = [MultivaluedOnlyInserViewController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivaluedOnlyDelete rowType:XLFormRowDescriptorTypeButton title:@"Multivalued Only Delete"];
    row.action.viewControllerClass = [MultivaluedOnlyDeleteViewController class];
    [section addFormRow:row];
    

    section = [XLFormSectionDescriptor formSectionWithTitle:@"UI Customization"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"UI Customization"];
    row.action.viewControllerClass = [UICustomizationFormViewController class];
    [section addFormRow:row];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Custom Rows"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"Custom Rows"];
    row.action.viewControllerClass = [CustomRowsViewController class];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Accessory View"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultivalued rowType:XLFormRowDescriptorTypeButton title:@"Accessory Views"];
    row.action.viewControllerClass = [AccessoryViewFormViewController class];
    [section addFormRow:row];

    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Validation Examples"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidations rowType:XLFormRowDescriptorTypeButton title:@"Validation Examples"];
    row.action.formSegueIdentifier = @"ValidationExamplesFormViewControllerSegue";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Using Predicates"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredicates rowType:XLFormRowDescriptorTypeButton title:@"Very basic predicates"];
    row.action.formSegueIdentifier = @"BasicPredicateViewControllerSegue";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredicates rowType:XLFormRowDescriptorTypeButton title:@"Blog Example Hide predicates"];
    row.action.formSegueIdentifier = @"BlogExampleViewSegue";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredicates rowType:XLFormRowDescriptorTypeButton title:@"Another example"];
    row.action.formSegueIdentifier = @"PredicateFormViewControllerSegue";
    [section addFormRow:row];
    
    self.form = form;

}



@end
