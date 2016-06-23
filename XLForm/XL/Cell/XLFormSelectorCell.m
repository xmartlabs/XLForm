//
//  XLFormSelectorCell.m
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

#import "XLForm.h"
#import "NSObject+XLFormAdditions.h"
#import "XLFormRowDescriptor.h"
#import "XLFormSelectorCell.h"
#import "NSArray+XLFormAdditions.h"

@interface XLFormSelectorCell() <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic) UIPickerView * pickerView;
@property (nonatomic) UIPopoverController *popoverController;

@end


@implementation XLFormSelectorCell
{
    UIColor * _beforeChangeColor;
}


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

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled && ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]));
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return  [self becomeFirstResponder];
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
    self.accessoryType = self.rowDescriptor.isDisabled || !([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelector]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;;
    self.editingAccessoryType = self.accessoryType;
    self.selectionStyle = self.rowDescriptor.isDisabled || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInfo] ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.textLabel.text = [NSString stringWithFormat:@"%@%@", self.rowDescriptor.title, self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle ? @"*" : @""];
    self.detailTextLabel.text = [self valueDisplayText];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover]){
        UIViewController * controllerToPresent = nil;
        if (self.rowDescriptor.action.formSegueIdentifier){
            [controller performSegueWithIdentifier:self.rowDescriptor.action.formSegueIdentifier sender:self.rowDescriptor];
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
                self.popoverController = [[UIPopoverController alloc] initWithContentViewController:selectorViewController];
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
        UIViewController * controllerToPresent = nil;
        XLFormOptionsViewController * optionsViewController = nil;
        if ((controllerToPresent = [self controllerToPresent])){
            optionsViewController = (XLFormOptionsViewController *)controllerToPresent;
        } else {
            optionsViewController = [[XLFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped titleHeaderSection:nil titleFooterSection:nil];
        }
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


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil];
        for (id option in self.rowDescriptor.selectorOptions) {
            [actionSheet addButtonWithTitle:[option displayText]];
        }
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        actionSheet.tag = [self.rowDescriptor hash];
        [actionSheet showInView:controller.view];
#else
        if ([UIAlertController class]) {
            XLFormViewController * formViewController = self.formViewController;
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            alertController.popoverPresentationController.sourceView = formViewController.tableView;
            UIView* v = (self.detailTextLabel ?: self.textLabel) ?: self.contentView;
            alertController.popoverPresentationController.sourceRect = [formViewController.tableView convertRect:v.frame fromView:self];
            __weak __typeof(self)weakSelf = self;
            for (id option in self.rowDescriptor.selectorOptions) {
				NSString *optionTitle = [option displayText];
				if (self.rowDescriptor.valueTransformer){
					NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
					NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
					NSString * transformedValue = [valueTransformer transformedValue:[option valueData]];
					if (transformedValue) {
						optionTitle = transformedValue;
					}
				}
                [alertController addAction:[UIAlertAction actionWithTitle:optionTitle
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [weakSelf.rowDescriptor setValue:option];
                                                                      [formViewController.tableView reloadData];
                                                                  }]];
            }
            [formViewController presentViewController:alertController animated:YES completion:nil];
        }
#ifndef XL_APP_EXTENSIONS
        else{
            UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                      delegate:self
                                                             cancelButtonTitle:nil
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:nil];
            for (id option in self.rowDescriptor.selectorOptions) {
                [actionSheet addButtonWithTitle:[option displayText]];
            }
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            actionSheet.tag = [self.rowDescriptor hash];
            [actionSheet showInView:controller.view];
        }
#endif
#endif
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorAlertView]){

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil];
        for (id option in self.rowDescriptor.selectorOptions) {
            [alertView addButtonWithTitle:[option displayText]];
        }
        alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
        alertView.tag = [self.rowDescriptor hash];
        [alertView show];
#else
        if ([UIAlertController class]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                      message:nil
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            __weak __typeof(self)weakSelf = self;
            for (id option in self.rowDescriptor.selectorOptions) {
                [alertController addAction:[UIAlertAction actionWithTitle:[option displayText]
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      [weakSelf.rowDescriptor setValue:option];
                                                                      [weakSelf.formViewController.tableView reloadData];
                                                                  }]];
            }
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                style:UIAlertActionStyleCancel
                                                              handler:nil]];
            [controller presentViewController:alertController animated:YES completion:nil];

        }
#ifndef XL_APP_EXTENSIONS
        else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:self.rowDescriptor.selectorTitle
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:nil];
            for (id option in self.rowDescriptor.selectorOptions) {
                [alertView addButtonWithTitle:[option displayText]];
            }
            alertView.cancelButtonIndex = [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            alertView.tag = [self.rowDescriptor hash];
            [alertView show];
        }
#endif
#endif
        [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        [controller.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)highlight
{
    [super highlight];
    _beforeChangeColor = self.detailTextLabel.textColor;
    self.detailTextLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    self.detailTextLabel.textColor = _beforeChangeColor;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

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

#endif

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (self.rowDescriptor.valueTransformer){
		NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
		NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
		NSString * tranformedValue = [valueTransformer transformedValue:[[self.rowDescriptor.selectorOptions objectAtIndex:row] valueData]];
		if (tranformedValue){
			return tranformedValue;
		}
	}
	return [[self.rowDescriptor.selectorOptions objectAtIndex:row] displayText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPickerView]){
        self.rowDescriptor.value = [self.rowDescriptor.selectorOptions objectAtIndex:row];
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
