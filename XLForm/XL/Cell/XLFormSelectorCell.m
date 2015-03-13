//
//  XLFormSelectorCell.m
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

#import "XLForm.h"
#import "NSObject+XLFormAdditions.h"
#import "XLFormRowDescriptor.h"
#import "XLFormSelectorCell.h"
#import "NSArray+XLFormAdditions.h"

@interface XLFormSelectorCell() <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic) UIPickerView * pickerView;

@end


@implementation XLFormSelectorCell

@synthesize popoverController;

-(NSString *)valueDisplayText
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]){
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0){
            return self.rowDescriptor.noValueDisplayText;
        }
        if (self.rowDescriptor.valueTransformer){
            NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
            NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
            NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
            if (tranformedValue){
                return tranformedValue;
            }
        }
        NSMutableArray * descriptionArray = [NSMutableArray arrayWithCapacity:[self.rowDescriptor.value count]];
        for (id option in self.rowDescriptor.selectorOptions) {
            NSArray * selectedValues = self.rowDescriptor.value;
            if ([selectedValues formIndexForItem:option] != NSNotFound){
                if (self.rowDescriptor.valueTransformer){
                    NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                    NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                    NSString * tranformedValue = [valueTransformer transformedValue:option];
                    if (tranformedValue){
                        [descriptionArray addObject:tranformedValue];
                    }
                }
                else{
                    [descriptionArray addObject:[option displayText]];
                }
                
                
            }
        }
        return [descriptionArray componentsJoinedByString:@", "];
    }
    if (!self.rowDescriptor.value){
        return self.rowDescriptor.noValueDisplayText;
    }
    if (self.rowDescriptor.valueTransformer){
        NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
        NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
        NSString * tranformedValue = [valueTransformer transformedValue:self.rowDescriptor.value];
        if (tranformedValue){
            return tranformedValue;
        }
    }
    return [self.rowDescriptor.value displayText];
}


-(UIView *)inputView
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        return self.pickerView;
    }
    return [super inputView];
}

- (BOOL)canBecomeFirstResponder
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        return YES;
    }
    return [super canBecomeFirstResponder];
}

#pragma mark - Properties

-(UIPickerView *)pickerView
{
    if (_pickerView) return _pickerView;
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:[self selectedIndex] inComponent:0 animated:NO];
    return _pickerView;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.accessoryType = self.rowDescriptor.disabled || !([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    [self.textLabel setText:self.rowDescriptor.title];
    self.textLabel.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.selectionStyle = self.rowDescriptor.disabled || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInfo] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]){
        UIViewController * controllerToPresent = nil;
        if (self.rowDescriptor.action.formSegueIdenfifier){
            [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdenfifier sender:self.rowDescriptor];
        }
        else if (self.rowDescriptor.action.formSegueClass){
            UIViewController * controllerToPresent = [self controllerToPresent];
            NSAssert(controllerToPresent, @"either rowDescriptor.action.viewControllerClass or rowDescriptor.action.viewControllerStoryboardId or rowDescriptor.action.viewControllerNibName must be assigned");
            NSAssert([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"selector view controller must conform to XLFormRowDescriptorViewController protocol");
            UIStoryboardSegue * segue = [[self.rowDescriptor.action.formSegueClass alloc] initWithIdentifier:self.rowDescriptor.tag source:controller destination:controllerToPresent];
            [controller prepareForSegue:segue sender:self.rowDescriptor];
            [segue perform];
        }
        else if ((controllerToPresent = [self controllerToPresent])){
            NSAssert([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"rowDescriptor.action.viewControllerClass must conform to XLFormRowDescriptorViewController protocol");
            UIViewController<XLFormRowDescriptorViewController> *selectorViewController = (UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent;
            selectorViewController.rowDescriptor = self.rowDescriptor;
            selectorViewController.title = self.rowDescriptor.selectorTitle;
            
            if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]) {
                if (self.popoverController && self.popoverController.popoverVisible) {
                    [self.popoverController dismissPopoverAnimated:NO];
                }
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectorViewController];
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
                self.popoverController.delegate = self;
                if ([selectorViewController conformsToProtocol:@protocol(XLFormRowDescriptorPopoverViewController)]){
                    ((id<XLFormRowDescriptorPopoverViewController>)selectorViewController).popoverController = self.popoverController;
                }
                if (self.detailTextLabel.window){
                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else{
                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
            }
            else {
                [controller.navigationController pushViewController:selectorViewController animated:YES];
            }
        }
        else if (self.rowDescriptor.selectorOptions){
            XLFormOptionsViewController * optionsViewController = [[XLFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
            optionsViewController.rowDescriptor = self.rowDescriptor;
            optionsViewController.title = self.rowDescriptor.selectorTitle;
			
			if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]) {
				self.popoverController = [[UIPopoverController alloc] initWithContentViewController:optionsViewController];
                self.popoverController.delegate = self;
                optionsViewController.popoverController = self.popoverController;
                if (self.detailTextLabel.window){
                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                else{
                    [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }
                [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
			} else {
				[controller.navigationController pushViewController:optionsViewController animated:YES];
			}
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover])
    {
        NSAssert(self.rowDescriptor.selectorOptions, @"selectorOptions property shopuld not be nil");
        XLFormOptionsViewController * optionsViewController = [[XLFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
        optionsViewController.rowDescriptor = self.rowDescriptor;
        optionsViewController.title = self.rowDescriptor.selectorTitle;
        
        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) {
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:optionsViewController];
            self.popoverController.delegate = self;
            optionsViewController.popoverController = self.popoverController;
            if (self.detailTextLabel.window){
                [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) inView:self.detailTextLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else{
                [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            [controller.tableView deselectRowAtIndexPath:[controller.tableView indexPathForCell:self] animated:YES];
        } else {
            [controller.navigationController pushViewController:optionsViewController animated:YES];
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorActionSheet]){
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        actionSheet.tag = [self.rowDescriptor hash];
        for (id option in self.rowDescriptor.selectorOptions) {
            [actionSheet addButtonWithTitle:[option displayText]];
        }
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        [actionSheet showInView:controller.view];
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorAlertView]){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.tag = [self.rowDescriptor hash];
        for (id option in self.rowDescriptor.selectorOptions) {
            [alertView addButtonWithTitle:[option displayText]];
        }
        alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        [alertView show];
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        [self becomeFirstResponder];
        [controller.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorActionSheet]){
        if ([actionSheet cancelButtonIndex] != buttonIndex){
            NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
            for (id option in self.rowDescriptor.selectorOptions){
                if ([[option displayText] isEqualToString:title]){
                    [self.rowDescriptor setValue:option];
                    [self.formViewController.tableView reloadData];
                    break;
                }
            }
        }
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorAlertView]){
        if ([alertView cancelButtonIndex] != buttonIndex){
            NSString * title = [alertView buttonTitleAtIndex:buttonIndex];
            for (id option in self.rowDescriptor.selectorOptions){
                if ([[option displayText] isEqualToString:title]){
                    [self.rowDescriptor setValue:option];
                    [self.formViewController.tableView reloadData];
                    break;
                }
            }
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(self.rowDescriptor.selectorOptions)[row] displayText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        self.rowDescriptor.value = (self.rowDescriptor.selectorOptions)[row];
        self.detailTextLabel.text = [self valueDisplayText];
        [self setNeedsLayout];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rowDescriptor.selectorOptions.count;
}


#pragma mark - Helpers

-(NSInteger)selectedIndex
{
    if (self.rowDescriptor.value){
        for (id option in self.rowDescriptor.selectorOptions){
            if ([[option valueData] isEqual:[self.rowDescriptor.value valueData]]){
                return [self.rowDescriptor.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

-(UIViewController *)controllerToPresent
{
    if (self.rowDescriptor.action.viewControllerClass){
        return [[self.rowDescriptor.action.viewControllerClass alloc] init];
    }
    else if ([self.rowDescriptor.action.viewControllerStoryboardId length] != 0){
        UIStoryboard * storyboard =  [self storyboardToPresent];
        NSAssert(storyboard != nil, @"You must provide a storyboard when rowDescriptor.action.viewControllerStoryboardId is used");
        return [storyboard instantiateViewControllerWithIdentifier:self.rowDescriptor.action.viewControllerStoryboardId];
    }
    else if ([self.rowDescriptor.action.viewControllerNibName length] != 0){
        Class viewControllerClass = NSClassFromString(self.rowDescriptor.action.viewControllerNibName);
        NSAssert(viewControllerClass, @"class owner of self.rowDescriptor.action.viewControllerNibName must be equal to %@", self.rowDescriptor.action.viewControllerNibName);
        return [[viewControllerClass alloc] initWithNibName:self.rowDescriptor.action.viewControllerNibName bundle:nil];
    }
    return nil;
}

-(UIStoryboard *)storyboardToPresent
{
    if ([self.formViewController respondsToSelector:@selector(storyboardForRow:)]){
        return [self.formViewController storyboardForRow:self.rowDescriptor];
    }
    if (self.formViewController.storyboard){
        return self.formViewController.storyboard;
    }
    return nil;
}


#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.formViewController.tableView reloadData];
}

@end
