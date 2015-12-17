//
//  XLFormInlineSegmentedCell.m
//  XLForm
//
//  Created by mathias Claassen on 16/12/15.
//  Copyright © 2015 Xmartlabs. All rights reserved.
//

#import "XLFormInlineSegmentedCell.h"

NSString * const XLFormRowDescriptorTypeSegmentedInline = @"XLFormRowDescriptorTypeSegmentedInline";
NSString * const XLFormRowDescriptorTypeSegmentedControl = @"XLFormRowDescriptorTypeSegmentedControl";

@implementation XLFormInlineSegmentedCell

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormInlineSegmentedCell class] forKey:XLFormRowDescriptorTypeSegmentedInline];
    [XLFormViewController.inlineRowDescriptorTypesForRowDescriptorTypes setObject:XLFormRowDescriptorTypeSegmentedControl forKey:XLFormRowDescriptorTypeSegmentedInline];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    if (self.isFirstResponder){
        return [super becomeFirstResponder];
    }
    BOOL result = [super becomeFirstResponder];
    if (result){
        XLFormRowDescriptor * inlineRowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes][self.rowDescriptor.rowType]];
        UITableViewCell<XLFormDescriptorCell> * cell = [inlineRowDescriptor cellForFormController:self.formViewController];
        NSAssert([cell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)], @"inline cell must conform to XLFormInlineRowDescriptorCell");
        UITableViewCell<XLFormInlineRowDescriptorCell> * inlineCell = (UITableViewCell<XLFormInlineRowDescriptorCell> *)cell;
        inlineCell.inlineRowDescriptor = self.rowDescriptor;
        [self.rowDescriptor.sectionDescriptor addFormRow:inlineRowDescriptor afterRow:self.rowDescriptor];
        [self.formViewController ensureRowIsVisible:inlineRowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    if (![self isFirstResponder]) {
        return [super resignFirstResponder];
    }
    NSIndexPath * selectedRowPath = [self.formViewController.form indexPathOfFormRow:self.rowDescriptor];
    NSIndexPath * nextRowPath = [NSIndexPath indexPathForRow:selectedRowPath.row + 1 inSection:selectedRowPath.section];
    XLFormRowDescriptor * nextFormRow = [self.formViewController.form formRowAtIndex:nextRowPath];
    XLFormSectionDescriptor * formSection = [self.formViewController.form.formSections objectAtIndex:nextRowPath.section];
    BOOL result = [super resignFirstResponder];
    if (result) {
        [formSection removeFormRow:nextFormRow];
    }
    return result;
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
}

-(void)update
{
    [super update];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.editingAccessoryType = UITableViewCellAccessoryNone;
    [self.textLabel setText:self.rowDescriptor.title];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailTextLabel.text = [self valueDisplayText];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !(self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    
    if ([self isFirstResponder]){
        [self resignFirstResponder];
        return NO;
    }
    return [self becomeFirstResponder];
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    [controller.tableView deselectRowAtIndexPath:[controller.form indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

#pragma mark - Helpers

-(NSString *)valueDisplayText
{
    return (self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText);
}



@end




@implementation XLFormInlineSegmentedControl

@synthesize segmentedControl = _segmentedControl;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;


+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[XLFormInlineSegmentedControl class] forKey:XLFormRowDescriptorTypeSegmentedControl];
}

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.segmentedControl];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[segmentedControl]-|"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:0
                                                                              views:@{@"segmentedControl": self.segmentedControl}]];
    [self.segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)update
{
    [super update];
    [self updateSegmentedControl];
    self.segmentedControl.selectedSegmentIndex = [self selectedIndex];
    self.segmentedControl.enabled = !self.rowDescriptor.isDisabled;
}

-(UISegmentedControl *)segmentedControl
{
    if (_segmentedControl) return _segmentedControl;
    
    _segmentedControl = [UISegmentedControl autolayoutView];
    [_segmentedControl setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    return _segmentedControl;
}


#pragma mark - Action

-(void)valueChanged
{
    self.inlineRowDescriptor.value = [self.inlineRowDescriptor.selectorOptions objectAtIndex:self.segmentedControl.selectedSegmentIndex];
    [self.formViewController updateFormRow:self.inlineRowDescriptor];
}

#pragma mark - Helper

-(NSArray *)getItems
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (id option in self.inlineRowDescriptor.selectorOptions)
        [result addObject:[option displayText]];
    return result;
}

-(void)updateSegmentedControl
{
    [self.segmentedControl removeAllSegments];
    
    [[self getItems] enumerateObjectsUsingBlock:^(id object, NSUInteger idex, __unused BOOL *stop){
        [self.segmentedControl insertSegmentWithTitle:[object displayText] atIndex:idex animated:NO];
    }];
}

-(NSInteger)selectedIndex
{
    XLFormRowDescriptor * formRow = self.inlineRowDescriptor ?: self.rowDescriptor;
    if (formRow.value){
        for (id option in formRow.selectorOptions){
            if ([[option valueData] isEqual:[formRow.value valueData]]){
                return [formRow.selectorOptions indexOfObject:option];
            }
        }
    }
    return -1;
}

@end
