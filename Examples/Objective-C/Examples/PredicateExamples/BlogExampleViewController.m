//
//  BlogExampleViewController.m
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

#import "BlogExampleViewController.h"

NSString *const kHobbies = @"hobbies";
NSString *const kSport = @"sport";
NSString *const kFilm = @"films1";
NSString *const kFilm2 = @"films2";
NSString *const kMusic = @"music";

@implementation BlogExampleViewController

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
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Blog Example: Hobbies"];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Hobbies"];
    [form addFormSection:section];
    
    XLFormRowDescriptor* hobbyRow = [XLFormRowDescriptor formRowDescriptorWithTag:kHobbies
                                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                                            title:@"Select Hobbies"];
    hobbyRow.selectorOptions = @[@"Sport", @"Music", @"Films"];
    hobbyRow.value = @[];
    [section addFormRow:hobbyRow];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Some more questions"];
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"$%@.value.@count == 0", hobbyRow]];
    section.footerTitle = @"BlogExampleViewController.m";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSport
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite sportsman?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sport'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite film?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm2
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite actor?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMusic
                                                rowType:XLFormRowDescriptorTypeTextView
                                                  title:@"Your favourite singer?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Music'", hobbyRow];
    [section addFormRow:row];
    
    self.form = form;
}


@end
