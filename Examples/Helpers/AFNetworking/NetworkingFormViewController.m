//
//  NetworkingFormViewController.h
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

#import "XLFOrm.h"
#import <XLDataLoader/XLNetworkStatusView.h>
#import "NetworkingFormViewController.h"


int const kActionSheetDeleteTag = 1;
NSString * const kDeleteButtonTag = @"DeleteButtonTag";

@interface NetworkingFormViewController()

@property (nonatomic)  MRProgressOverlayView * progressView;
@property (nonatomic) XLNetworkStatusView * networkStatusView;

@end

@implementation NetworkingFormViewController

@synthesize cancelButton = _cancelButton;
@synthesize saveButton = _saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtonCaption
{
    return [self initWithForm:form formMode:mode showCancelButton:showCancelButton showSaveButton:showSaveButton showDeleteButton:showDeleteButton deleteButtonCaption:deleteButtonCaption tableStyle:UITableViewStyleGrouped];
}

-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtonCaption tableStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self){
        _formMode = mode;
        _showCancelButton = showCancelButton;
        _showSaveButton = showSaveButton;
        _showDeleteButton = showDeleteButton;
        _deleteButtonCaption = deleteButtonCaption;
    }
    return self;
}


-(void)networkingFormViewControllerDefaultInitialize
{
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
    // Do any additional setup after loading the view.
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

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showNetworkReachability){
        [self updateNetworkReachabilityView];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkingReachabilityDidChange:)
                                                     name:AFNetworkingReachabilityDidChangeNotification
                                                   object:nil];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.showNetworkReachability){
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AFNetworkingReachabilityDidChangeNotification
                                                      object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _progressView = nil;
    _formDataManager = nil;
}


-(void)showServerErrorMessage:(NSError *)error
{
    
}

-(AFHTTPSessionManager *)sessionManager
{
    return nil;
}

-(XLFormDataManager *)createFormDataManager
{
    return [[XLFormDataManager alloc] init];
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

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    XLFormRowDescriptor * row = [self.form formRowAtIndex:indexPath];
    if ([row.tag isEqualToString:kDeleteButtonTag])
    {
        [self deletePressed];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.networkStatusView.frame;
    frame.origin.y = MAX(scrollView.contentOffset.y + scrollView.contentInset.top, 0);
    self.networkStatusView.frame = frame;
}


@end
