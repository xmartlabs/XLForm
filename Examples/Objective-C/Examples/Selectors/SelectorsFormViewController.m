//
//  SelectorsFormViewController.m
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
#import "DynamicSelectorsFormViewController.h"
#import "SelectorsFormViewController.h"

NSString *const kSelectorPush = @"selectorPush";
NSString *const kSelectorPopover = @"selectorPopover";
NSString *const kSelectorActionSheet = @"selectorActionSheet";
NSString *const kSelectorAlertView = @"selectorAlertView";
NSString *const kSelectorLeftRight = @"selectorLeftRight";
NSString *const kSelectorPushDisabled = @"selectorPushDisabled";
NSString *const kSelectorActionSheetDisabled = @"selectorActionSheetDisabled";
NSString *const kSelectorLeftRightDisabled = @"selectorLeftRightDisabled";
NSString *const kSelectorPickerView = @"selectorPickerView";
NSString *const kSelectorPickerViewInline = @"selectorPickerViewInline";
NSString *const kMultipleSelector = @"multipleSelector";
NSString *const kMultipleSelectorPopover = @"multipleSelectorPopover";
NSString *const kDynamicSelectors = @"dynamicSelectors";
NSString *const kCustomSelectors = @"customSelectors";
NSString *const kPickerView = @"pickerView";
NSString *const kSelectorWithSegueId = @"selectorWithSegueId";
NSString *const kSelectorWithSegueClass = @"selectorWithSegueClass";
NSString *const kSelectorWithNibName = @"selectorWithNibName";
NSString *const kSelectorWithStoryboardId = @"selectorWithStoryboardId";

#pragma mark - NSValueTransformer

@interface NSArrayValueTrasformer : NSValueTransformer
@end

@implementation NSArrayValueTrasformer

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
    if ([value isKindOfClass:[NSArray class]]){
        NSArray * array = (NSArray *)value;
        return [NSString stringWithFormat:@"%@ Item%@", @(array.count), array.count > 1 ? @"s" : @""];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@ - ;) - Transformed", value];
    }
    return nil;
}

@end


@interface ISOLanguageCodesValueTranformer : NSValueTransformer
@end

@implementation ISOLanguageCodesValueTranformer

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
    if ([value isKindOfClass:[NSString class]]){
        return [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:value];
    }
    return nil;
}

@end


#pragma mark - SelectorsFormViewController

@implementation SelectorsFormViewController

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
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Selectors"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Basic Information
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Selectors"];
    section.footerTitle = @"SelectorsFormViewController.h";
    [form addFormSection:section];
    
    
    // Selector Push
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorPush rowType:XLFormRowDescriptorTypeSelectorPush title:@"Push"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"];
    [section addFormRow:row];
    
    // Selector Popover
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorPopover rowType:XLFormRowDescriptorTypeSelectorPopover title:@"PopOver"];
        row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
        row.value = @"Option 2";
        [section addFormRow:row];
    }
    
    // Selector Action Sheet
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorActionSheet rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sheet"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"];
    [section addFormRow:row];
    
    
    
    
    // Selector Alert View
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorAlertView rowType:XLFormRowDescriptorTypeSelectorAlertView title:@"Alert View"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"];
    [section addFormRow:row];
    
    
    
    // Selector Left Right
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorLeftRight rowType:XLFormRowDescriptorTypeSelectorLeftRight title:@"Left Right"];
    row.leftRightSelectorLeftOptionSelected = [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"];
    
    NSArray * rightOptions =  @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Right Option 1"],
                                [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Right Option 2"],
                                [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Right Option 3"],
                                [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Right Option 4"],
                                [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Right Option 5"]
                                ];
    
    // create right selectors
    NSMutableArray * leftRightSelectorOptions = [[NSMutableArray alloc] init];
    NSMutableArray * mutableRightOptions = [rightOptions mutableCopy];
    [mutableRightOptions removeObjectAtIndex:0];
    XLFormLeftRightSelectorOption * leftRightSelectorOption = [XLFormLeftRightSelectorOption formLeftRightSelectorOptionWithLeftValue:[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"] httpParameterKey:@"option_1" rightOptions:mutableRightOptions];
    [leftRightSelectorOptions addObject:leftRightSelectorOption];
    
    mutableRightOptions = [rightOptions mutableCopy];
    [mutableRightOptions removeObjectAtIndex:1];
    leftRightSelectorOption = [XLFormLeftRightSelectorOption formLeftRightSelectorOptionWithLeftValue:[XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"] httpParameterKey:@"option_2" rightOptions:mutableRightOptions];
    leftRightSelectorOption.leftValueChangePolicy = XLFormLeftRightSelectorOptionLeftValueChangePolicyChooseFirstOption;
    [leftRightSelectorOptions addObject:leftRightSelectorOption];
    
    mutableRightOptions = [rightOptions mutableCopy];
    [mutableRightOptions removeObjectAtIndex:2];
    leftRightSelectorOption = [XLFormLeftRightSelectorOption formLeftRightSelectorOptionWithLeftValue:[XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"]  httpParameterKey:@"option_3" rightOptions:mutableRightOptions];
    leftRightSelectorOption.leftValueChangePolicy = XLFormLeftRightSelectorOptionLeftValueChangePolicyChooseLastOption;
    [leftRightSelectorOptions addObject:leftRightSelectorOption];
    
    mutableRightOptions = [rightOptions mutableCopy];
    [mutableRightOptions removeObjectAtIndex:3];
    leftRightSelectorOption = [XLFormLeftRightSelectorOption formLeftRightSelectorOptionWithLeftValue:[XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"] httpParameterKey:@"option_4" rightOptions:mutableRightOptions];
    [leftRightSelectorOptions addObject:leftRightSelectorOption];
    
    mutableRightOptions = [rightOptions mutableCopy];
    [mutableRightOptions removeObjectAtIndex:4];
    leftRightSelectorOption = [XLFormLeftRightSelectorOption formLeftRightSelectorOptionWithLeftValue:[XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"] httpParameterKey:@"option_5" rightOptions:mutableRightOptions];
    [leftRightSelectorOptions addObject:leftRightSelectorOption];
    
    row.selectorOptions  = leftRightSelectorOptions;
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Right Option 4"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorPickerView rowType:XLFormRowDescriptorTypeSelectorPickerView title:@"Picker View"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Option 1"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Option 2"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(2) displayText:@"Option 3"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@(4) displayText:@"Option 5"]
                            ];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:@(3) displayText:@"Option 4"];
    [section addFormRow:row];
    
    
    
    // --------- Fixed Controls
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Fixed Controls"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPickerView rowType:XLFormRowDescriptorTypePicker];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.value = @"Option 1";
    [section addFormRow:row];
    
    
    
    // --------- Inline Selectors
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Inline Selectors"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultipleSelector rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"Inline Picker View"];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.value = @"Option 6";
    [section addFormRow:row];
    
    // --------- MultipleSelector
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Multiple Selectors"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultipleSelector rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Multiple Selector"];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.value = @[@"Option 1", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    [section addFormRow:row];
    
    
    // Multiple selector with value tranformer
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultipleSelector rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Multiple Selector"];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.value = @[@"Option 1", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.valueTransformer = [NSArrayValueTrasformer class];
    [section addFormRow:row];
    
    
    // Language multiple selector
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultipleSelector rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Multiple Selector"];
    row.selectorOptions = [NSLocale ISOLanguageCodes];
    row.selectorTitle = @"Languages";
    row.valueTransformer = [ISOLanguageCodesValueTranformer class];
    row.value = [NSLocale preferredLanguages];
    [section addFormRow:row];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        // Language multiple selector popover
        row = [XLFormRowDescriptor formRowDescriptorWithTag:kMultipleSelectorPopover rowType:XLFormRowDescriptorTypeMultipleSelectorPopover title:@"Multiple Selector PopOver"];
        row.selectorOptions = [NSLocale ISOLanguageCodes];
        row.valueTransformer = [ISOLanguageCodesValueTranformer class];
        row.value = [NSLocale preferredLanguages];
        [section addFormRow:row];
    }
    
    
    // --------- Dynamic Selectors
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Dynamic Selectors"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDynamicSelectors rowType:XLFormRowDescriptorTypeButton title:@"Dynamic Selectors"];
    row.action.viewControllerClass = [DynamicSelectorsFormViewController class];
    [section addFormRow:row];
    
    // --------- Custom Selectors
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Custom Selectors"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCustomSelectors rowType:XLFormRowDescriptorTypeButton title:@"Custom Selectors"];
    row.action.viewControllerClass = [CustomSelectorsFormViewController class];
    [section addFormRow:row];
    
    
    // --------- Selector definition types
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Selectors"];
    [form addFormSection:section];
    
    // selector with segue class
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorWithSegueClass rowType:XLFormRowDescriptorTypeSelectorPush title:@"Selector with Segue Class"];
    row.action.formSegueClass = NSClassFromString(@"UIStoryboardPushSegue");
    row.action.viewControllerClass = [MapViewController class];
    row.valueTransformer = [CLLocationValueTrasformer class];
    row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    [section addFormRow:row];
    
    // selector with SegueId
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorWithSegueId rowType:XLFormRowDescriptorTypeSelectorPush title:@"Selector with Segue Identifier"];
    row.action.formSegueIdentifier = @"MapViewControllerSegue";
    row.valueTransformer = [CLLocationValueTrasformer class];
    row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    [section addFormRow:row];
    
    // selector using StoryboardId
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorWithStoryboardId rowType:XLFormRowDescriptorTypeSelectorPush title:@"Selector with StoryboardId"];
    row.action.viewControllerStoryboardId = @"MapViewController";
    row.valueTransformer = [CLLocationValueTrasformer class];
    row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    [section addFormRow:row];
    
    // selector with NibName
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSelectorWithNibName rowType:XLFormRowDescriptorTypeSelectorPush title:@"Selector with NibName"];
    row.action.viewControllerNibName = @"MapViewController";
    row.valueTransformer = [CLLocationValueTrasformer class];
    row.value = [[CLLocation alloc] initWithLatitude:-33 longitude:-56];
    [section addFormRow:row];
    
    
    
    self.form = form;
}


-(UIStoryboard *)storyboardForRow:(XLFormRowDescriptor *)formRow
{
    return [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
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
