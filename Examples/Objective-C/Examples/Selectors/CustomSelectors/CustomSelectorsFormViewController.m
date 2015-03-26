//
//  CustomSelectorsFormViewController.m
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

#import <MapKit/MapKit.h>
#import "CLLocationValueTrasformer.h"
#import "MapViewController.h"

#import "CustomSelectorsFormViewController.h"

NSString *const kSelectorMap = @"selectorMap";
NSString *const kSelectorMapPopover = @"selectorMapPopover";

@implementation CustomSelectorsFormViewController

-(id)init
{
    self = [super init];
    if (self) {
        XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Custom Selectors"];
        XLFormSectionDescriptor * section;
        XLFormRowDescriptor * row;
        
        // Basic Information
        section = [XLFormSectionDescriptor formSection];
        section.footerTitle = @"CustomSelectorsFormViewController.h";
        [form addFormSection:section];
        
        
        // Selector Push
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorMap rowType:XLFormRowDescriptorTypeSelectorPush title:@"Coordinate"];
        row.action.viewControllerClass = [MapViewController class];
        row.valueTransformer = [CLLocationValueTrasformer class];
        row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
        [section addFormRow:row];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            // Selector PopOver
            row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorMapPopover rowType:XLFormRowDescriptorTypeSelectorPopover title:@"Coordinate PopOver"];
            row.action.viewControllerClass = [MapViewController class];
            row.valueTransformer = [CLLocationValueTrasformer class];
            row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
            [section addFormRow:row];
        }
        
        self.form = form;
        
    }
    return self;
}

@end
