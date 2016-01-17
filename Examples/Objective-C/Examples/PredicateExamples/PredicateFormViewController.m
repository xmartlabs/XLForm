//
//  PredicateFormViewController.m
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

NSString *const kPred = @"pred";
NSString *const kPredDep = @"preddep";
NSString *const kPredDep2 = @"preddep2";

#import "PredicateFormViewController.h"

@implementation PredicateFormViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}


- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * pred, *pred3, *pred4;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Predicates example"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Independent rows"];
    

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep rowType:XLFormRowDescriptorTypeAccount title:@"Text"];
    [row.cellConfigAtConfigure setObject:@"Type disable" forKey:@"textField.placeholder"];
    pred = row;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPredDep2 rowType:XLFormRowDescriptorTypeInteger title:@"Integer"];
    row.hidden = [NSString stringWithFormat:@"$switch==0"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"switch" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Boolean"];
    row.value = @1;
    pred3 = row;
    [section addFormRow:row];
    
    [form addFormSection:section];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Dependent section"];
    section.footerTitle = @"Type disable in the textfield, a number between 18 and 60 in the integer field or use the switch to disable the last row. By doing all three the last section will hide.\nThe integer field hides when the boolean switch is set to 0.";
    [form addFormSection:section];
    
    // Predicate Disabling
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPred rowType:XLFormRowDescriptorTypeDateInline title:@"Disabled"];
    row.value = [NSDate new];
    [section addFormRow:row];
    
    row.disabled = [NSString stringWithFormat:@"$%@ contains[c] 'disable' OR ($%@.value between {18, 60}) OR ($%@.value == 0)", pred, kPredDep2, pred3];
    //[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] %%@) OR ($%@.value between {18, 60}) OR ($%@.value == 0)", pred, pred2, pred3],  @"disable"] ];
    pred4 = row;

    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"($%@.value contains[c] 'disable') AND ($%@.value between {18, 60}) AND ($%@.value == 0)", pred, kPredDep2, pred3]];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"More predicates..."];
    section.footerTitle = @"This row hides when the row of the previous section is disabled and the textfield in the first section contains \"out\"\n\nPredicateFormViewController.m";
    [form addFormSection:section];
    

    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"thirds" rowType:XLFormRowDescriptorTypeAccount title:@"Account"];
    [section addFormRow:row];
    row.hidden = [NSString stringWithFormat:@"$%@.isDisabled == 1 AND $%@.value contains[c] 'Out'", pred4, pred];
    
    typeof(self) __weak weakself = self;
    row.onChangeBlock = ^(id oldValue, id newValue, XLFormRowDescriptor* __unused rowDescriptor){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Account Field changed" message:[NSString stringWithFormat:@"Old value: %@\nNew value: %@", oldValue, newValue ] preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil]];
        [weakself.navigationController presentViewController:alert animated:YES completion:nil];
    };
    
    self.form = form;
}

@end
