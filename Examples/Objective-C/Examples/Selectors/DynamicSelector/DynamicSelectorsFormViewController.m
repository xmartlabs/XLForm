//
//  DynamicSelectorsFormViewController.m
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

#import "UsersTableViewController.h"
#import "DynamicSelectorsFormViewController.h"

NSString *const kSelectorUser = @"selectorUser";
NSString *const kSelectorUserPopover = @"kSelectorUserPopover";

@interface UserTransformer : NSValueTransformer
@end

@implementation UserTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    NSDictionary *user = (NSDictionary *) value;
    return [user valueForKeyPath:@"user.name"];
}

@end

@implementation DynamicSelectorsFormViewController

-(id)init
{
    self = [super init];
    if (self) {
        XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Selectors"];
        XLFormSectionDescriptor * section;
        XLFormRowDescriptor * row;
        
        // Basic Information
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Dynamic Selectors"];
        section.footerTitle = @"DynamicSelectorsFormViewController.h";
        [form addFormSection:section];
        
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorUser rowType:XLFormRowDescriptorTypeSelectorPush title:@"User"];
        row.action.viewControllerStoryboardId = @"UsersTableViewController";
        row.valueTransformer = [UserTransformer class];
        [section addFormRow:row];
        
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
//            // Selector PopOver
//            row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorUserPopover rowType:XLFormRowDescriptorTypeSelectorPopover title:@"User Popover"];
//            row.action.viewControllerClass = [UsersTableViewController class];
//            [section addFormRow:row];
//        }
        self.form = form;
    }
    return self;
}

- (UIStoryboard *)storyboardForRow:(XLFormRowDescriptor *)formRow
{
    return [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
}

@end
