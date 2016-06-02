//
//  XLFormViewController.m
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

#import "UIView+XLFormAdditions.h"
#import "NSObject+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "UIView+XLFormAdditions.h"
#import "XLForm.h"
#import "NSString+XLFormAdditions.h"


@interface XLFormRowDescriptor(_XLFormViewController)

@property (readonly) NSArray * observers;
-(BOOL)evaluateIsDisabled;
-(BOOL)evaluateIsHidden;

@end

@interface XLFormSectionDescriptor(_XLFormViewController)

-(BOOL)evaluateIsHidden;

@end

@interface XLFormDescriptor (_XLFormViewController)

@property NSMutableDictionary* rowObservers;

@end


@interface XLFormViewController()
{
    NSNumber *_oldBottomTableContentInset;
    CGRect _keyboardFrame;
}
@property UITableViewStyle tableViewStyle;
@property (nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;

@end

@implementation XLFormViewController

@synthesize form = _form;

#pragma mark - Initialization

-(id)initWithForm:(XLFormDescriptor *)form
{
    return [self initWithForm:form style:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form style:(UITableViewStyle)style
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        _tableViewStyle = style;
        _form = form;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _form = nil;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _form = nil;
        _tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.tableView){
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                      style:self.tableViewStyle];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if([self.tableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]){
            self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
    }
    if (!self.tableView.superview){
        [self.view addSubview:self.tableView];
    }
    if (!self.tableView.delegate){
        self.tableView.delegate = self;
    }
    if (!self.tableView.dataSource){
        self.tableView.dataSource = self;
    }
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
    _oldBottomTableContentInset = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if (selected){
        // Trigger a cell refresh
        XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:selected];
        [self updateFormRow:rowDescriptor];
        [self.tableView selectRowAtIndexPath:selected animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:selected animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
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
                                               XLFormRowDescriptorTypeZipCode: [XLFormTextFieldCell class],
                                               XLFormRowDescriptorTypeSelectorPush: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorPopover: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorActionSheet: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorAlertView: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorPickerView: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorPickerViewInline: [XLFormInlineSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorSegmentedControl: [XLFormSegmentedCell class],
                                               XLFormRowDescriptorTypeMultipleSelector: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeMultipleSelectorPopover: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeImage: [XLFormImageCell class],
                                               XLFormRowDescriptorTypeTextView: [XLFormTextViewCell class],
                                               XLFormRowDescriptorTypeButton: [XLFormButtonCell class],
                                               XLFormRowDescriptorTypeInfo: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeBooleanSwitch : [XLFormSwitchCell class],
                                               XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                               XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimer : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeCountDownTimerInline : [XLFormDateCell class],
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
                                                            XLFormRowDescriptorTypeTimeInline: XLFormRowDescriptorTypeDatePicker,
                                                            XLFormRowDescriptorTypeCountDownTimerInline: XLFormRowDescriptorTypeDatePicker
                                                            } mutableCopy];
    });
    return _inlineRowDescriptorTypesForRowDescriptorTypes;
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:[self insertRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:[self deleteRowAnimationForRow:formRow]];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenRemoved:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self deleteRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

-(void)formSectionHasBeenAdded:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:[self insertRowAnimationForSection:formSection]];
    [self.tableView endUpdates];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    [self updateAfterDependentRowChanged:formRow];
}

-(void)formRowDescriptorPredicateHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue predicateType:(XLPredicateType)predicateType
{
    if (oldValue != newValue) {
        [self updateAfterDependentRowChanged:formRow];
    }
}

-(void)updateAfterDependentRowChanged:(XLFormRowDescriptor *)formRow
{
    NSMutableArray* revaluateHidden   = self.form.rowObservers[[formRow.tag formKeyForPredicateType:XLPredicateTypeHidden]];
    NSMutableArray* revaluateDisabled = self.form.rowObservers[[formRow.tag formKeyForPredicateType:XLPredicateTypeDisabled]];
    for (id object in revaluateDisabled) {
        if ([object isKindOfClass:[NSString class]]) {
            XLFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsDisabled];
                [self updateFormRow:row];
            }
        }
    }
    for (id object in revaluateHidden) {
        if ([object isKindOfClass:[NSString class]]) {
            XLFormRowDescriptor* row = [self.form formRowWithTag:object];
            if (row){
                [row evaluateIsHidden];
            }
        }
        else if ([object isKindOfClass:[XLFormSectionDescriptor class]]) {
            XLFormSectionDescriptor* section = (XLFormSectionDescriptor*) object;
            [section evaluateIsHidden];
        }
    }
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
    if ([[formRow cellForFormController:self] respondsToSelector:@selector(formDescriptorCellDidSelectedWithFormController:)]){
        [[formRow cellForFormController:self] formDescriptorCellDidSelectedWithFormController:self];
    }
}

-(UITableViewRowAnimation)insertRowAnimationForRow:(XLFormRowDescriptor *)formRow
{
    if (formRow.sectionDescriptor.sectionOptions & XLFormSectionOptionCanInsert){
        if (formRow.sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeButton){
            return UITableViewRowAnimationAutomatic;
        }
        else if (formRow.sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeLastRow){
            return YES;
        }
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

-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    if ((self.form.rowNavigationOptions & XLFormRowNavigationOptionEnabled) != XLFormRowNavigationOptionEnabled){
        return nil;
    }
    if ([[[[self class] inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:rowDescriptor.rowType]) {
        return nil;
    }
    UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[rowDescriptor cellForFormController:self];
    if (![cell formDescriptorCellCanBecomeFirstResponder]){
        return nil;
    }
    XLFormRowDescriptor * previousRow = [self nextRowDescriptorForRow:rowDescriptor
                                                            withDirection:XLFormRowNavigationDirectionPrevious];
    XLFormRowDescriptor * nextRow     = [self nextRowDescriptorForRow:rowDescriptor
                                                            withDirection:XLFormRowNavigationDirectionNext];
    [self.navigationAccessoryView.previousButton setEnabled:(previousRow != nil)];
    [self.navigationAccessoryView.nextButton setEnabled:(nextRow != nil)];
    return self.navigationAccessoryView;
}

-(void)beginEditing:(XLFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] highlight];
}

-(void)endEditing:(XLFormRowDescriptor *)rowDescriptor
{
    [[rowDescriptor cellForFormController:self] unhighlight];
}

-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)formSection
{
    if (formSection.multivaluedRowTemplate){
        return [formSection.multivaluedRowTemplate copy];
    }
    XLFormRowDescriptor * formRowDescriptor = [[formSection.formRows objectAtIndex:0] copy];
    formRowDescriptor.tag = nil;
    return formRowDescriptor;
}

-(void)multivaluedInsertButtonTapped:(XLFormRowDescriptor *)formRow
{
    [self deselectFormRow:formRow];
    XLFormSectionDescriptor * multivaluedFormSection = formRow.sectionDescriptor;
    XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
    [multivaluedFormSection addFormRow:formRowDescriptor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.editing = !self.tableView.editing;
        self.tableView.editing = !self.tableView.editing;
    });
    UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[formRowDescriptor cellForFormController:self];
    if ([cell formDescriptorCellCanBecomeFirstResponder]){
        [cell formDescriptorCellBecomeFirstResponder];
    }
}

-(void)ensureRowIsVisible:(XLFormRowDescriptor *)inlineRowDescriptor
{
    XLFormBaseCell * inlineCell = [inlineRowDescriptor cellForFormController:self];
    NSIndexPath * indexOfOutOfWindowCell = [self.form indexPathOfFormRow:inlineRowDescriptor];
    if(!inlineCell.window || (self.tableView.contentOffset.y + self.tableView.frame.size.height <= inlineCell.frame.origin.y + inlineCell.frame.size.height)){
        [self.tableView scrollToRowAtIndexPath:indexOfOutOfWindowCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Methods

-(NSArray *)formValidationErrors
{
    return [self.form localValidationErrors:self];
}

-(void)showFormValidationError:(NSError *)error
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 80000
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                         message:error.localizedDescription
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
    [alertView show];
#else
    if ([UIAlertController class]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                                                  message:error.localizedDescription
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
#ifndef XL_APP_EXTENSIONS
    else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"XLFormViewController_ValidationErrorTitle", nil)
                                                             message:error.localizedDescription
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                   otherButtonTitles:nil];
        [alertView show];
    }
#endif
#endif
}

-(void)performFormSelector:(SEL)selector withObject:(id)sender
{
    UIResponder * responder = [self targetForAction:selector withSender:sender];;
    if (responder) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [responder performSelector:selector withObject:sender];
#pragma GCC diagnostic pop
    }
}

#pragma mark - Private

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView * firstResponderView = [self.tableView findFirstResponder];
    UITableViewCell<XLFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        NSDictionary *keyboardInfo = [notification userInfo];
        _keyboardFrame = [self.tableView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.tableView.superview];
        CGFloat newBottomInset = self.tableView.frame.origin.y + self.tableView.frame.size.height - _keyboardFrame.origin.y;
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        _oldBottomTableContentInset = _oldBottomTableContentInset ?: @(tableContentInset.bottom);
        if (newBottomInset > [_oldBottomTableContentInset floatValue]){
            tableContentInset.bottom = newBottomInset;
            tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
            [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
            self.tableView.contentInset = tableContentInset;
            self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
            NSIndexPath *selectedRow = [self.tableView indexPathForCell:cell];
            [self.tableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [UIView commitAnimations];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIView * firstResponderView = [self.tableView findFirstResponder];
    UITableViewCell<XLFormDescriptorCell> * cell = [firstResponderView formDescriptorCell];
    if (cell){
        _keyboardFrame = CGRectZero;
        NSDictionary *keyboardInfo = [notification userInfo];
        UIEdgeInsets tableContentInset = self.tableView.contentInset;
        UIEdgeInsets tableScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        tableContentInset.bottom = [_oldBottomTableContentInset floatValue];
        tableScrollIndicatorInsets.bottom = tableContentInset.bottom;
        _oldBottomTableContentInset = nil;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        self.tableView.contentInset = tableContentInset;
        self.tableView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        [UIView commitAnimations];
    }
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

-(XLFormBaseCell *)updateFormRow:(XLFormRowDescriptor *)formRow
{
    XLFormBaseCell * cell = [formRow cellForFormController:self];
    [self configureCell:cell];
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
    return cell;
}

-(void)configureCell:(XLFormBaseCell*) cell
{
    [cell update];
    [cell.rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
        [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
    if (cell.rowDescriptor.isDisabled){
        [cell.rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
            [cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }];
    }
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
    [self updateFormRow:rowDescriptor];
    return [rowDescriptor cellForFormController:self];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    if (rowDescriptor.isDisabled || !rowDescriptor.sectionDescriptor.isMultivaluedSection){
        return NO;
    }
    XLFormBaseCell * baseCell = [rowDescriptor cellForFormController:self];
    if ([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor){
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    XLFormSectionDescriptor * section = rowDescriptor.sectionDescriptor;
    if (section.sectionOptions & XLFormSectionOptionCanReorder && section.formRows.count > 1) {
        if (section.sectionInsertMode == XLFormSectionInsertModeButton && section.sectionOptions & XLFormSectionOptionCanInsert){
            if (section.formRows.count <= 2 || rowDescriptor == section.multivaluedAddButton){
                return NO;
            }
        }
        XLFormBaseCell * baseCell = [rowDescriptor cellForFormController:self];
        return !([baseCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)baseCell).inlineRowDescriptor);
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:sourceIndexPath];
    XLFormSectionDescriptor * section = row.sectionDescriptor;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [section performSelector:NSSelectorFromString(@"moveRowAtIndexPath:toIndexPath:") withObject:sourceIndexPath withObject:destinationIndexPath];
#pragma GCC diagnostic pop
    // update the accessory view
    [self inputAccessoryViewForRowDescriptor:row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.editing = !self.tableView.editing;
        self.tableView.editing = !self.tableView.editing;
    });

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        XLFormRowDescriptor * multivaluedFormRow = [self.form formRowAtIndex:indexPath];
        // end editing
        UIView * firstResponder = [[multivaluedFormRow cellForFormController:self] findFirstResponder];
        if (firstResponder){
                [self.tableView endEditing:YES];
        }
        [multivaluedFormRow.sectionDescriptor removeFormRowAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.editing = !self.tableView.editing;
            self.tableView.editing = !self.tableView.editing;
        });
        if (firstResponder){
            UITableViewCell<XLFormDescriptorCell> * firstResponderCell = [firstResponder formDescriptorCell];
            XLFormRowDescriptor * rowDescriptor = firstResponderCell.rowDescriptor;
            [self inputAccessoryViewForRowDescriptor:rowDescriptor];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){

        XLFormSectionDescriptor * multivaluedFormSection = [self.form formSectionAtIndex:indexPath.section];
        if (multivaluedFormSection.sectionInsertMode == XLFormSectionInsertModeButton && multivaluedFormSection.sectionOptions & XLFormSectionOptionCanInsert){
            [self multivaluedInsertButtonTapped:multivaluedFormSection.multivaluedAddButton];
        }
        else{
            XLFormRowDescriptor * formRowDescriptor = [self formRowFormMultivaluedFormSection:multivaluedFormSection];
            [multivaluedFormSection addFormRow:formRowDescriptor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.editing = !self.tableView.editing;
                self.tableView.editing = !self.tableView.editing;
            });
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[formRowDescriptor cellForFormController:self];
            if ([cell formDescriptorCellCanBecomeFirstResponder]){
                [cell formDescriptorCellBecomeFirstResponder];
            }
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
    [rowDescriptor cellForFormController:self];
    CGFloat height = rowDescriptor.height;
    if (height != XLFormUnspecifiedCellHeight){
        return height;
    }
    return self.tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor *rowDescriptor = [self.form formRowAtIndex:indexPath];
    [rowDescriptor cellForFormController:self];
    CGFloat height = rowDescriptor.height;
    if (height != XLFormUnspecifiedCellHeight){
        return height;
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        return self.tableView.estimatedRowHeight;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if (row.isDisabled) {
        return;
    }
    UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[row cellForFormController:self];
    if (!([cell formDescriptorCellCanBecomeFirstResponder] && [cell formDescriptorCellBecomeFirstResponder])){
        [self.tableView endEditing:YES];
    }
    [self didSelectFormRow:row];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    XLFormSectionDescriptor * section = row.sectionDescriptor;
    if (section.sectionOptions & XLFormSectionOptionCanInsert){
        if (section.formRows.count == indexPath.row + 2){
            if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:row.rowType]){
                UITableViewCell<XLFormDescriptorCell> * cell = [row cellForFormController:self];
                UIView * firstResponder = [cell findFirstResponder];
                if (firstResponder){
                    return UITableViewCellEditingStyleInsert;
                }
            }
        }
        else if (section.formRows.count == (indexPath.row + 1)){
            return UITableViewCellEditingStyleInsert;
        }
    }
    if (section.sectionOptions & XLFormSectionOptionCanDelete){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    }
    XLFormSectionDescriptor * sectionDescriptor = [self.form formSectionAtIndex:sourceIndexPath.section];
    XLFormRowDescriptor * proposedDestination = [sectionDescriptor.formRows objectAtIndex:proposedDestinationIndexPath.row];
    XLFormBaseCell * proposedDestinationCell = [proposedDestination cellForFormController:self];
    if (([proposedDestinationCell conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)] && ((id<XLFormInlineRowDescriptorCell>)proposedDestinationCell).inlineRowDescriptor) || ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:proposedDestinationCell.rowDescriptor.rowType] && [[proposedDestinationCell findFirstResponder] formDescriptorCell] == proposedDestinationCell)) {
        if (sourceIndexPath.row < proposedDestinationIndexPath.row){
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row + 1 inSection:sourceIndexPath.section];
        }
        else{
            return [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row - 1 inSection:sourceIndexPath.section];
        }
    }

    if ((sectionDescriptor.sectionInsertMode == XLFormSectionInsertModeButton && sectionDescriptor.sectionOptions & XLFormSectionOptionCanInsert)){
        if (proposedDestinationIndexPath.row == sectionDescriptor.formRows.count - 1){
            return [NSIndexPath indexPathForRow:(sectionDescriptor.formRows.count - 2) inSection:sourceIndexPath.section];
        }
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle editingStyle = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleNone){
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // end editing if inline cell is first responder
    UITableViewCell<XLFormDescriptorCell> * cell = [[self.tableView findFirstResponder] formDescriptorCell];
    if ([[self.form indexPathOfFormRow:cell.rowDescriptor] isEqual:indexPath]){
        if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            [self.tableView endEditing:YES];
        }
    }
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
    XLFormRowDescriptor * currentRow = cell.rowDescriptor;
    XLFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:currentRow
                                                    withDirection:XLFormRowNavigationDirectionNext];
    if (nextRow){
        UITableViewCell<XLFormDescriptorCell> * nextCell = (UITableViewCell<XLFormDescriptorCell> *)[nextRow cellForFormController:self];
        if ([nextCell formDescriptorCellCanBecomeFirstResponder]){
            [nextCell formDescriptorCellBecomeFirstResponder];
            return YES;
        }
    }
    [self.tableView endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell<XLFormDescriptorCell>* cell = textField.formDescriptorCell;
    XLFormRowDescriptor * nextRow     = [self nextRowDescriptorForRow:textField.formDescriptorCell.rowDescriptor
                                                        withDirection:XLFormRowNavigationDirectionNext];
    
    
    if ([cell conformsToProtocol:@protocol(XLFormReturnKeyProtocol)]) {
        textField.returnKeyType = nextRow ? ((id<XLFormReturnKeyProtocol>)cell).nextReturnKeyType : ((id<XLFormReturnKeyProtocol>)cell).returnKeyType;
    }
    else {
        textField.returnKeyType = nextRow ? UIReturnKeyNext : UIReturnKeyDefault;
    }
    return YES;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    if (NO == self.form.endEditingTableViewOnScroll) {
        return;
    }

    UIView * firstResponder = [self.tableView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(XLFormDescriptorCell)]){
        id<XLFormDescriptorCell> cell = (id<XLFormDescriptorCell>)firstResponder;
        if ([[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes].allKeys containsObject:cell.rowDescriptor.rowType]){
            return;
        }
    }
    [self.tableView endEditing:YES];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[XLFormRowDescriptor class]]){
        UIViewController * destinationViewController = segue.destinationViewController;
        XLFormRowDescriptor * rowDescriptor = (XLFormRowDescriptor *)sender;
        if (rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorPush || rowDescriptor.rowType == XLFormRowDescriptorTypeSelectorPopover){
            NSAssert([destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)], @"Segue destinationViewController must conform to XLFormRowDescriptorViewController protocol");
            UIViewController<XLFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<XLFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
        else if ([destinationViewController conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
            UIViewController<XLFormRowDescriptorViewController> * rowDescriptorViewController = (UIViewController<XLFormRowDescriptorViewController> *)destinationViewController;
            rowDescriptorViewController.rowDescriptor = rowDescriptor;
        }
    }
}

#pragma mark - Navigation Between Fields


-(void)rowNavigationAction:(UIBarButtonItem *)sender
{
    [self navigateToDirection:(sender == self.navigationAccessoryView.nextButton ? XLFormRowNavigationDirectionNext : XLFormRowNavigationDirectionPrevious)];
}

-(void)rowNavigationDone:(UIBarButtonItem *)sender
{
    [self.tableView endEditing:YES];
}

-(void)navigateToDirection:(XLFormRowNavigationDirection)direction
{
    UIView * firstResponder = [self.tableView findFirstResponder];
    UITableViewCell<XLFormDescriptorCell> * currentCell = [firstResponder formDescriptorCell];
    NSIndexPath * currentIndexPath = [self.tableView indexPathForCell:currentCell];
    XLFormRowDescriptor * currentRow = [self.form formRowAtIndex:currentIndexPath];
    XLFormRowDescriptor * nextRow = [self nextRowDescriptorForRow:currentRow withDirection:direction];
    if (nextRow) {
        UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[nextRow cellForFormController:self];
        if ([cell formDescriptorCellCanBecomeFirstResponder]){
            NSIndexPath * indexPath = [self.form indexPathOfFormRow:nextRow];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [cell formDescriptorCellBecomeFirstResponder];
        }
    }
}

-(XLFormRowDescriptor *)nextRowDescriptorForRow:(XLFormRowDescriptor*)currentRow withDirection:(XLFormRowNavigationDirection)direction
{
    if (!currentRow || (self.form.rowNavigationOptions & XLFormRowNavigationOptionEnabled) != XLFormRowNavigationOptionEnabled) {
        return nil;
    }
    XLFormRowDescriptor * nextRow = (direction == XLFormRowNavigationDirectionNext) ? [self.form nextRowDescriptorForRow:currentRow] : [self.form previousRowDescriptorForRow:currentRow];
    if (!nextRow) {
        return nil;
    }
    if ([[nextRow cellForFormController:self] conformsToProtocol:@protocol(XLFormInlineRowDescriptorCell)]) {
        id<XLFormInlineRowDescriptorCell> inlineCell = (id<XLFormInlineRowDescriptorCell>)[nextRow cellForFormController:self];
        if (inlineCell.inlineRowDescriptor){
            return [self nextRowDescriptorForRow:nextRow withDirection:direction];
        }
    }
    XLFormRowNavigationOptions rowNavigationOptions = self.form.rowNavigationOptions;
    if (nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionStopDisableRow) == XLFormRowNavigationOptionStopDisableRow)){
        return nil;
    }
    if (!nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionStopInlineRow) == XLFormRowNavigationOptionStopInlineRow) && [[[XLFormViewController inlineRowDescriptorTypesForRowDescriptorTypes] allKeys] containsObject:nextRow.rowType]){
        return nil;
    }
    UITableViewCell<XLFormDescriptorCell> * cell = (UITableViewCell<XLFormDescriptorCell> *)[nextRow cellForFormController:self];
    if (!nextRow.isDisabled && ((rowNavigationOptions & XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) != XLFormRowNavigationOptionSkipCanNotBecomeFirstResponderRow) && (![cell formDescriptorCellCanBecomeFirstResponder])){
        return nil;
    }
    if (!nextRow.isDisabled && [cell formDescriptorCellCanBecomeFirstResponder]){
        return nextRow;
    }
    return [self nextRowDescriptorForRow:nextRow withDirection:direction];
}

#pragma mark - properties

-(void)setForm:(XLFormDescriptor *)form
{
    _form.delegate = nil;
    [self.tableView endEditing:YES];
    _form = form;
    _form.delegate = self;
    [_form forceEvaluate];
    if ([self isViewLoaded]){
        [self.tableView reloadData];
    }
}

-(XLFormDescriptor *)form
{
    return _form;
}

-(XLFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.previousButton.target = self;
    _navigationAccessoryView.previousButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.nextButton.target = self;
    _navigationAccessoryView.nextButton.action = @selector(rowNavigationAction:);
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(rowNavigationDone:);
    _navigationAccessoryView.tintColor = self.view.tintColor;
    return _navigationAccessoryView;
}

@end

