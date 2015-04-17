//
//  BlogExampleViewController.m
//  XLForm
//
//  Created by mathias Claassen on 16/4/15.
//  Copyright (c) 2015 Xmartlabs. All rights reserved.
//

#import "BlogExampleViewController.h"

NSString *const kHobbies = @"hobbies";
NSString *const kSport = @"sport";
NSString *const kFilm = @"films1";
NSString *const kFilm2 = @"films2";
NSString *const kMusic = @"music";

@interface BlogExampleViewController ()

@end

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
    
    XLFormRowDescriptor* hobbyRow = [XLFormRowDescriptor formRowDescriptorWithTag:kHobbies rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Select Hobbies"];
    hobbyRow.selectorOptions = @[@"Sport", @"Music", @"Films"];
    hobbyRow.value = @[];
    [section addFormRow:hobbyRow];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Some more questions"];
    section.hidden = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"$%@.value.@count = 0", hobbyRow]];
    section.footerTitle = @"BlogExampleViewController.m";
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSport rowType:XLFormRowDescriptorTypeTextView title:@"Your favourite sportsman?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sport'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm rowType:XLFormRowDescriptorTypeTextView title:@"Your favourite film?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFilm2 rowType:XLFormRowDescriptorTypeTextView title:@"Your favourite actor?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Films'", hobbyRow];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMusic rowType:XLFormRowDescriptorTypeTextView title:@"Your favourite singer?"];
    row.hidden = [NSString stringWithFormat:@"NOT $%@ contains 'Music'", hobbyRow];
    [section addFormRow:row];
    
    self.form = form;
}


@end
