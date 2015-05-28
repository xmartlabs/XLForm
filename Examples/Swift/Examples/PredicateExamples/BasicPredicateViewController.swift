//
//  BasicPredicateViewController.m
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

#import "BasicPredicateViewController.h"

NSString *const khiderow = @"tag1";
NSString *const khidesection = @"tag2";
NSString *const ktext = @"tag3";

@implementation BasicPredicateViewController
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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Basic Predicates"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"A Section"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khiderow rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Show next row"];
    row.value = @0;
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khidesection rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Show B Section"];
    row.hidden = [NSString stringWithFormat:@"$%@==0", khiderow];
    row.value = @0;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"B Section"];
    section.footerTitle = @"BasicPredicateViewController";
    section.hidden = [NSString stringWithFormat:@"$%@==0", khidesection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:ktext rowType:XLFormRowDescriptorTypeText title:@""];
    [row.cellConfigAtConfigure setObject:@"Gonna disappear soon!!" forKey:@"textField.placeholder"];
    [section addFormRow:row];
    
    self.form = form;
}

@end
