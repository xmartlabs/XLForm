//
//  OthersFormViewController.m
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

#import "MapViewController.h"
#import "OthersFormViewController.h"

NSString *const kSwitchBool = @"switchBool";
NSString *const kSwitchCheck = @"switchBool";
NSString *const kStepCounter = @"stepCounter";
NSString *const kSlider = @"slider";
NSString *const kSegmentedControl = @"segmentedControl";
NSString *const kCustom = @"custom";
NSString *const kInfo = @"info";
NSString *const kButton = @"button";
NSString *const kButtonLeftAligned = @"buttonLeftAligned";
NSString *const kButtonWithSegueId = @"buttonWithSegueId";
NSString *const kButtonWithSegueClass = @"buttonWithSegueClass";
NSString *const kButtonWithNibName = @"buttonWithNibName";
NSString *const kButtonWithStoryboardId = @"buttonWithStoryboardId";


@implementation OthersFormViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}

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
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchBool rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Switch"]];
    
    // check
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kSwitchCheck rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Check"]];
    
    // step counter
    [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:kStepCounter rowType:XLFormRowDescriptorTypeStepCounter title:@"Step counter"]];
    
    // Segmented Control
    XLFormRowDescriptor * row = [XLFormRowDescriptor formRowDescriptorWithTag:kSegmentedControl rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Fruits"];
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
    

    // Info cell
    XLFormRowDescriptor *infoRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kInfo rowType:XLFormRowDescriptorTypeInfo];
    infoRowDescriptor.title = @"Version";
    infoRowDescriptor.value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [section addFormRow:infoRowDescriptor];
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Buttons"];
    section.footerTitle = @"Blue buttons will show a message when Switch is ON";
    [form addFormSection:section];
    
    // Button
    XLFormRowDescriptor * buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"Button"];
    [buttonRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    buttonRow.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:buttonRow];
    
    
    // Left Button
    XLFormRowDescriptor * buttonLeftAlignedRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonLeftAligned rowType:XLFormRowDescriptorTypeButton title:@"Button with Block"];
    [buttonLeftAlignedRow.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
    [buttonLeftAlignedRow.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [buttonLeftAlignedRow.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    buttonLeftAlignedRow.action.formBlock = ^(XLFormRowDescriptor * sender){
        if ([[sender.sectionDescriptor.formDescriptor formRowWithTag:kSwitchBool].value boolValue]){
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Switch is ON", nil) message:@"Button has checked the switch value..." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alertView show];
        }
        [self deselectFormRow:sender];
    };
    [section addFormRow:buttonLeftAlignedRow];
    
    // Another Left Button with segue
    XLFormRowDescriptor * buttonLeftAlignedWithSegueRow = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithSegueClass rowType:XLFormRowDescriptorTypeButton title:@"Button with Segue Class"];
    buttonLeftAlignedWithSegueRow.action.formSegueClass = NSClassFromString(@"UIStoryboardPushSegue");
    buttonLeftAlignedWithSegueRow.action.viewControllerClass = [MapViewController class];
    [section addFormRow:buttonLeftAlignedWithSegueRow];
    
    
    // Button with SegueId
    XLFormRowDescriptor * buttonWithSegueId = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithSegueClass rowType:XLFormRowDescriptorTypeButton title:@"Button with Segue Idenfifier"];
    buttonWithSegueId.action.formSegueIdenfifier = @"MapViewControllerSegue";
    [section addFormRow:buttonWithSegueId];
    
    
    // Another Button using Segue
    XLFormRowDescriptor * buttonWithStoryboardId = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithStoryboardId rowType:XLFormRowDescriptorTypeButton title:@"Button with StoryboardId"];
    buttonWithStoryboardId.action.viewControllerStoryboardId = @"MapViewController";
    [section addFormRow:buttonWithStoryboardId];
    
    // Another Left Button with segue
    XLFormRowDescriptor * buttonWithNibName = [XLFormRowDescriptor formRowDescriptorWithTag:kButtonWithNibName
                                                                                    rowType:XLFormRowDescriptorTypeButton
                                                                                      title:@"Button with NibName"];
    buttonWithNibName.action.viewControllerNibName = @"MapViewController";
    [section addFormRow:buttonWithNibName];
    
    self.form = form;
}

-(void)didTouchButton:(XLFormRowDescriptor *)sender
{
    if ([[sender.sectionDescriptor.formDescriptor formRowWithTag:kSwitchBool].value boolValue]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Switch is ON", nil) message:@"Button has checked the switch value..." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    }
    [self deselectFormRow:sender];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"Disable" style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(disableEnable:)];
    barButton.possibleTitles = [NSSet setWithObjects:@"Disable", @"Enable", nil];
    self.navigationItem.rightBarButtonItem = barButton;
}

-(void)disableEnable:(UIBarButtonItem *)button
{
    self.form.disabled = !self.form.disabled;
    [button setTitle:(self.form.disabled ? @"Enable" : @"Disable")];
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
}


@end
