//
//  XLFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Created by Martin Barreto on 31/3/14.
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

#import <XLDataLoader/XLNetworkStatusView.h>
#import <MRProgress/MRProgress.h>
#import "XLFormDataManager.h"
#import "XLFormSelectorTableViewController.h"
#import "NSObject+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "UIView+XLFormAdditions.h"
#import "XLForm.h"

int const kActionSheetDeleteTag = 1;
NSString * const kDeleteButtonTag = @"DeleteButtonTag";


@interface XLFormViewController()

@property (nonatomic)  MRProgressOverlayView * progressView;
@property UITableViewStyle tableViewStyle;
@property (nonatomic) XLNetworkStatusView * networkStatusView;

@end


@implementation XLFormViewController


@synthesize cancelButton = _cancelButton;
@synthesize saveButton = _saveButton;


-(id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form
{
    return [self initWithForm:form formMode:XLFormModeCreate showCancelButton:NO showSaveButton:NO showDeleteButton:NO deleteButtonCaption:nil];
}

-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtonCaption
{
    return [self initWithForm:form formMode:mode showCancelButton:showCancelButton showSaveButton:showSaveButton showDeleteButton:showDeleteButton deleteButtonCaption:deleteButtonCaption tableStyle:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtonCaption tableStyle:(UITableViewStyle)style
{
    self = [self initWithStyle:style];
    if (self){
        _form = form;
        _formMode = mode;
        _showCancelButton = showCancelButton;
        _showSaveButton = showSaveButton;
        _showDeleteButton = showDeleteButton;
        _deleteButtonCaption = deleteButtonCaption;
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self defaultInitialize];
        _tableViewStyle = style;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultInitialize];
}

-(void)defaultInitialize
{
    _form = nil;
    _formMode = XLFormModeCreate;
    _showCancelButton = NO;
    _showSaveButton = NO;
    _showDeleteButton = NO;
    _showNetworkReachability = YES;
    _deleteButtonCaption = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.showCancelButton){
        self.navigationItem.leftBarButtonItem = self.cancelButton;
    }
    if (self.showSaveButton){
        self.navigationItem.rightBarButtonItem = self.saveButton;
    }
    if (self.showDeleteButton){
        XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
        [self.form addFormSection:section];
        XLFormRowDescriptor * deleteButtonDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kDeleteButtonTag rowType:XLFormRowDescriptorTypeButton];
        deleteButtonDescriptor.title = self.deleteButtonCaption ?: NSLocalizedString(@"Delete", @"Delete");
        [deleteButtonDescriptor.cellConfig setObject:[UIColor redColor] forKey:@"textLabel.textColor"];
        [section addFormRow:deleteButtonDescriptor];
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
    if (self.showNetworkReachability){
        [self updateNetworkReachabilityView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkingReachabilityDidChange:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
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
    if (self.showNetworkReachability){
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AFNetworkingReachabilityDidChangeNotification
                                                      object:nil];
    }
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
    _progressView = nil;
    _formDataManager = nil;
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
                                               XLFormRowDescriptorTypeSelectorPush: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorActionSheet: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeSelectorAlertView: [XLFormSelectorCell class],
                                               XLFormRowDescriptorTypeTextView: [XLFormTextViewCell class],
                                               XLFormRowDescriptorTypeButton: [XLFormButtonCell class],
                                               XLFormRowDescriptorTypeBooleanSwitch : [XLFormSwitchCell class],
                                               XLFormRowDescriptorTypeBooleanCheck : [XLFormCheckCell class],
                                               XLFormRowDescriptorTypeDate: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTime: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTime : [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDateTimeInline: [XLFormDateCell class],
                                               XLFormRowDescriptorTypeDatePicker : [XLFormDatePickerCell class],
                                               XLFormRowDescriptorTypeSelectorLeftRight : [XLFormLeftRightSelectorCell class],
                                               XLFormRowDescriptorTypeImage: [XLFormImageSelectorCell class]
                                               } mutableCopy];
    });
    return _cellClassesForRowDescriptorTypes;
}


#pragma mark - XLFormDescriptorDelegate

-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
}

-(void)formRowHasBeenRemovedAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
}

-(void)formSectionHasBeenRemovedAtIndex:(NSUInteger)index
{
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)formSectionHasBeenAdded:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
}

#pragma mark - XLFormViewControllerDelegate

-(AFHTTPSessionManager *)sessionManager
{
    return nil;
}

-(NSDictionary *)httpParameters
{
    return [self.form httpParameters:self];
}

-(XLFormDataManager *)createFormDataManager
{
    return [[XLFormDataManager alloc] init];
}


-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow
{
    if ([[formRow cellForFormController:self]  respondsToSelector:@selector(formDescriptorCellDidSelectedWithFormController:)]){
        [[formRow cellForFormController:self] formDescriptorCellDidSelectedWithFormController:self];
    }
}



#pragma mark - Actions

-(void)cancelPressed:(UIBarButtonItem *)cancelButton
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)savePressed:(UIBarButtonItem *)saveButton
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    self.formDataManager = [self createFormDataManager];
    if ([self respondsToSelector:@selector(configureDataManager:)]){
        [self configureDataManager:self.formDataManager];
        self.formDataManager.delegate = self;
        [self.formDataManager forceReload];
    }
}

-(void)deletePressed
{
    UIActionSheet *confirm = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"XLFormController_DeleteConfirmation", @"Are you sure?")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
                                                otherButtonTitles:nil];
    confirm.tag = kActionSheetDeleteTag;
    [confirm showInView:self.tableView];
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

-(void)showServerErrorMessage:(NSError *)error
{
}

#pragma mark - Properties

-(MRProgressOverlayView *)progressView
{
    if (_progressView) return _progressView;
    _progressView = [[MRProgressOverlayView alloc] init];
    _progressView.titleLabelText = NSLocalizedString(@"Loading", nil);
    if (self.tabBarController){
        [self.tabBarController.view addSubview:_progressView];
    }
    else if (self.navigationController){
        [self.navigationController.view addSubview:_progressView];
    }
    else{
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

-(UIBarButtonItem *)cancelButton
{
    if (_cancelButton) return _cancelButton;
    _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    return _cancelButton;
}

-(UIBarButtonItem *)saveButton
{
    if (_saveButton) return _saveButton;
    _saveButton = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savePressed:)];
    return _saveButton;
}

-(XLNetworkStatusView *)networkStatusView
{
    if (!_networkStatusView){
        _networkStatusView = [[XLNetworkStatusView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        _networkStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _networkStatusView;
}

-(BOOL)showNetworkReachability
{
    return (_showNetworkReachability && [self sessionManager] != nil);
}

#pragma mark - Private

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

-(void)networkingReachabilityDidChange:(NSNotification *)notification
{
    [self updateNetworkReachabilityView];
}

-(void)updateNetworkReachabilityView
{
    if (![self.sessionManager.reachabilityManager networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        if ([self.networkStatusView superview]){
            [self.networkStatusView removeFromSuperview];
        }
    }
    else{
        if (![self.networkStatusView superview]){
            [self.tableView addSubview:self.networkStatusView];
        }
    }
}

#pragma mark - Helpers

-(void)setActivityIndicatorMode:(MRProgressOverlayViewMode)mode
{
    self.progressView.mode = mode;
}

-(void)showActivityIndicator
{
    self.progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.progressView show:YES];
}

-(void)hideActivityIndicator
{
    [self.progressView hide:YES];
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
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
    return formDescriptorCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * rowDescriptor = [self.form formRowAtIndex:indexPath];
    ((UITableViewCell<XLFormDescriptorCell> *)cell).rowDescriptor = rowDescriptor;
    [rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL *stop) {
        [cell setValue:value forKeyPath:keyPath];
    }];
    [cell setNeedsUpdateConstraints];
    [cell setNeedsLayout];
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
        XLFormRowDescriptor * formRowDescriptor = [multivaluedFormSection newMultivaluedFormRowDescriptor];
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
    if ([cellClass respondsToSelector:@selector(formDescriptorCellHeightForRowDescription:)]){
        return [cellClass formDescriptorCellHeightForRowDescription:rowDescriptor];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if (row.disabled) {
        //[self.tableView endEditing:YES];
        return;
    }
    else if (!([[row cellForFormController:self] respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)] && [[row cellForFormController:self] formDescriptorCellBecomeFirstResponder])){
        [self.tableView endEditing:YES];
    }
    [self didSelectFormRow:row];
    if ([row.tag isEqualToString:kDeleteButtonTag])
    {
        [self deletePressed];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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


-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case kActionSheetDeleteTag:
        {
            if (buttonIndex == actionSheet.destructiveButtonIndex) {
                [self.tableView endEditing:YES];
                if ([self respondsToSelector:@selector(configureDataManager:)]){
                    _formMode = XLFormModeDelete;
                    self.formDataManager = [self createFormDataManager];
                    [self configureDataManager:self.formDataManager];
                    self.formDataManager.delegate = self;
                    [self.formDataManager forceReload];
                }
            }
            break;
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}

#pragma mark - XLDataLoaderDelegate

-(void)dataLoaderDidStartLoadingData:(XLDataLoader *)dataLoader
{
    [self showActivityIndicator];
}

-(void)dataLoaderDidLoadData:(XLDataLoader *)dataSource
{
    self.progressView.mode = MRProgressOverlayViewModeCheckmark;
    [self performBlock:^{
        [self hideActivityIndicator];
        if (self.delegate){
            [self.delegate formViewControllerDidFinish:self];
        }
    } afterDelay:1.5];
}

-(void)dataLoaderDidFailLoadData:(XLDataLoader *)dataSource withError:(NSError *)error
{
    self.progressView.mode = MRProgressOverlayViewModeCross;
    if (self.formMode == XLFormModeDelete) {
        // if _fromMode == XLFormModeDelete, then the user enter in edit mode and press the delete button. If the deletion
        // fail then is needed to set back the formMode to edit again.
        _formMode = XLFormModeEdit;
    }
    [self performBlock:^{
        [self hideActivityIndicator];
        [self showServerErrorMessage:error];
    } afterDelay:2.0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    UIView * firstResponder = [self.tableView findFirstResponder];
    if ([firstResponder conformsToProtocol:@protocol(XLFormDescriptorCell)]){
        id<XLFormDescriptorCell> cell = (id<XLFormDescriptorCell>)firstResponder;
        if ([cell.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDateInline] || [cell.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeTimeInline] || [cell.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDateTimeInline]){
            return;
        }
    }
    [self.tableView endEditing:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.networkStatusView.frame;
    frame.origin.y = MAX(scrollView.contentOffset.y + scrollView.contentInset.top, 0);
    self.networkStatusView.frame = frame;
}


@end
