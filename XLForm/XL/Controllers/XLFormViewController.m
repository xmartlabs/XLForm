//
//  XLFormViewController.m
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

#import "NSObject+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "UIView+XLFormAdditions.h"
#import "XLForm.h"


@interface XLFormViewController()

@property UITableViewStyle tableViewStyle;

@end


@implementation XLFormViewController

-(id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self){
        self.form = form;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self defaultInitialize];
    }
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self defaultInitialize];
    }
    return self;
}

-(void)defaultInitialize
{
    _form = nil;
    _tableViewStyle = UITableViewStyleGrouped;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44.0;
    }
    if (self.form.title){
        self.title = self.form.title;
    }
    [self.tableView setEditing:YES animated:NO];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.form.delegate = self;
    self.clearsSelectionOnViewWillAppear = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected){
        [self.tableView reloadRowsAtIndexPaths:@[selected] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.form.assignFirstResponderOnShow) {
        self.form.assignFirstResponderOnShow = NO;
        [self.form setFirstResponder:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CellClasses

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes
{
    static NSMutableDictionary * _cellClassesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cellClassesForRowDescriptorTypes = [@{XLFormRowDescriptorTypeText:[XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeName: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypePhone:[XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeURL:[XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeEmail: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeTwitter: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeAccount: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypePassword: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeNumber: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeInteger: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeDecimal: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeSelectorPush: [XLFormSelectorCell class],
											   XLFormRowDescriptorTypeSelectorPopover: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorActionSheet: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorAlertView: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorPickerView: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorPickerViewInline: [XLFormInlineSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorSegmentedControl: [XLFormSegmentedCell class],
                                               XLFormRowDescriptorTypeMultipleSelector: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeMultipleSelectorPopover: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeTextView: [XLFormTextViewCell class],
                                               XLFormRowDescriptorTypeButton: [XLFormButtonCell class],
                                               XLFormRowDescriptorTypeInfo: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeBooleanSwitch : [XLFormSwitchCell class],
                                               XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                               XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDatePicker : [XLFormDatePickerCell class],
                                               XLFormRowDescriptorTypePicker : [XLFormPickerCell class],
											   XLFormRowDescriptorTypeSlider : [XLFormSliderCell class],
                                               XLFormRowDescriptorTypeSelectorLeftRight : [XLFormLeftRightSelectorCell class],
                                               XLFormRowDescriptorTypeStepCounter: [XLFormStepCounterCell class]
                                               } mutableCopy];
    });
    return _cellClassesForRowDescriptorTypes;
}

#pragma mark - inlineRowDescriptorTypes

+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes
{
    static NSMutableDictionary * _inlineRowDescriptorTypesForRowDescriptorTypes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inlineRowDescriptorTypesForRowDescriptorTypes = [
  @{XLFormRowDescriptorTypeSelectorPickerViewInline: XLFormRowDescriptorTypePicker,
    XLFormRowDescriptorTypeDateInline: XLFormRowDescriptorTypeDatePicker,
    XLFormRowDescriptorTypeDateTimeInline: XLFormRowDescriptorTypeDatePicker,
    XLFormRowDescriptorTypeTimeInline: XLFormRowDescriptorTypeDatePicker
                                                            } mutableCopy];
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;

}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:[self insertRowAnimationForRow:formRow]];
}

-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:[self deleteRowAnimationForRow:formRow]];
}

-(void)formSectionHasBeenRemoved:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self deleteRowAnimationForSection:formSection]];
}

-(void)formSectionHasBeenAdded:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self insertRowAnimationForSection:formSection]];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
}

#pragma mark - XLFormViewControllerDelegate

-(NSDictionary *)formValues
{
    return [self.form formValues];
}

-(NSDictionary *)httpParameters
{
    return [self.form httpParameters:self];
}


-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    if ([[formRow cellForFormController:self]  respondsToSelector:@selector(formDescriptorCellDidSelectedWithFormController:)]){
        [[formRow cellForFormController:self] formDescriptorCellDidSelectedWithFormController:self];
    }
}

-(UITableViewRowAnimation)insertRowAnimationForRow:(XLFormRowDescriptor *)formRow
{
    if (formRow.sectionDescriptor.isMultivaluedSection){
        return YES;
    }
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)deleteRowAnimationForRow:(XLFormRowDescriptor *)formRow
{
    return UITableViewRowAnimationFade;
}

-(UITableViewRowAnimation)insertRowAnimationForSection:(XLFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

-(UITableViewRowAnimation)deleteRowAnimationForSection:(XLFormSectionDescriptor *)formSection
{
    return UITableViewRowAnimationAutomatic;
}

#pragma mark - Methods

-(NSArray *)formValidationErrors
{
    return [self.form localValidationErrors:self];
}

-(void)showFormValidationError:(NSError *)error
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil) message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Private

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark - Helpers

-(void)deselectFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)reloadFormRow:(XLFormRowDescriptor *)formRow
{
    NSIndexPath * indexPath = [self.form indexPathOfFormRow:formRow];
    if (indexPath){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(NSIndexPath *)nextIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableView numberOfRowsInSection:indexPath.section] > (indexPath.row + 1)){
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
    else if ([self.tableView numberOfSections] > (indexPath.section + 1)){
        if ([self.tableView numberOfRowsInSection:(indexPath.section + 1)] > 0){
            return [NSIndexPath indexPathForRow:0 inSection:(indexPath.section + 1)];
        }
    }
    return nil;
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.form.formSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.form.formSections.count){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
    }
    return [[[self.form.formSections objectAtIndex:section] formRows] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:indexPath];
    UITableViewCell<XLFormDescriptorCell> * formDescriptorCell = [rowDescriptor cellForFormController:self];
    ((XLFormBaseCell *)formDescriptorCell).formViewController = self;

    ((UITableViewCell<XLFormDescriptorCell> *)formDescriptorCell).rowDescriptor = rowDescriptor;
    [rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
        [formDescriptorCell setValue:value forKeyPath:keyPath];
    }];
    [formDescriptorCell setNeedsLayout];

    return formDescriptorCell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.form formSectionAtIndex:indexPath.section].isMultivaluedSection;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormSectionDescriptor * multivaluedFormSection = [self.form formSectionAtIndex:indexPath.section];
        [multivaluedFormSection removeFormRowAtIndex:indexPath.row];
        self.tableView.editing = NO;
        self.tableView.editing = YES;

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        XLFormSectionDescriptor * multivaluedFormSection = [self.form formSectionAtIndex:indexPath.section];
        XLFormRowDescriptor * formRowDescriptor = [self respondsToSelector:@selector(formRowFormMultivaluedFormSection:)] ? [self formRowFormMultivaluedFormSection:multivaluedFormSection] : [multivaluedFormSection newMultivaluedFormRowDescriptor];
        [multivaluedFormSection addFormRow:formRowDescriptor];
        self.tableView.editing = NO;
        self.tableView.editing = YES;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        if ([[formRowDescriptor cellForFormController:self] respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)]){
            [[formRowDescriptor cellForFormController:self] formDescriptorCellBecomeFirstResponder];
        }
    }
}

#pragma mark - UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.form.formSections objectAtIndex:section] title];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[self.form.formSections objectAtIndex:section] footerTitle];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    Class cellClass = rowDescriptor.cellClass ?: [XLFormViewController cellClassesForRowDescriptorTypes][rowDescriptor.rowType];
    if ([cellClass respondsToSelector:@selector(formDescriptorCellHeightForRowDescriptor:)]){
        return [cellClass formDescriptorCellHeightForRowDescriptor:rowDescriptor];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        return -1;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if (row.disabled) {
        return;
    }
    else if (!([[row cellForFormController:self] respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)] && [[row cellForFormController:self] formDescriptorCellBecomeFirstResponder])){
        [self.tableView endEditing:YES];
    }
    [self didSelectFormRow:row];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.form formSectionAtIndex:indexPath.section].formRows.count == (indexPath.row + 1)){
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // called when 'return' key pressed. return NO to ignore.
    UITableViewCell<XLFormDescriptorCell> * cell = [textField formDescriptorCell];
    NSIndexPath * currentIndexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath * nextIndexPath = [self nextIndexPath:currentIndexPath];

    if (nextIndexPath){
        XLFormRowDescriptor * nextFormRow = [self.form formRowAtIndex:nextIndexPath];
        UITableViewCell<XLFormDescriptorCell> * nextCell = (UITableViewCell<XLFormDescriptorCell> *)[nextFormRow cellForFormController:self];
        if ([nextCell respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)]){
            [nextCell formDescriptorCellBecomeFirstResponder];
            return YES;
        }
    }
    if ([cell respondsToSelector:@selector(formDescriptorCellResignFirstResponder)]){
        [cell formDescriptorCellResignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return !self.readOnlyMode;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return !self.readOnlyMode;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    UIView * firstResponder = [self.tableView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(XLFormDescriptorCell)]){
        id<XLFormDescriptorCell> cell = (id<XLFormDescriptorCell>)firstResponder;
        if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            return;
        }
    }
    [self.tableView endEditing:YES];
}



@end
