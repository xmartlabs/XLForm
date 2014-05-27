//
//  NetworkingFormViewController.m
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

#import <MRProgress/MRProgress.h>
#import "XLFormDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import <XLDataLoader/XLDataLoader.h>
#import "XLFormViewController.h"

NSString * const kDeleteButtonTag;

typedef NS_ENUM(NSUInteger, XLFormMode)
{
    XLFormModeCreate = 0,
    XLFormModeEdit,
    XLFormModeDelete
};

@protocol NetworkingFormViewControllerDelegate <NSObject>

@optional
-(void)configureDataManager:(XLFormDataManager *)dataManager;

@end


@protocol XLFormViewControllerPresenting <NSObject>

@required

-(void)formViewControllerDidFinish:(XLFormViewController *)formViewController;

@end


@interface NetworkingFormViewController : XLFormViewController<XLDataLoaderDelegate, NetworkingFormViewControllerDelegate>

-(AFHTTPSessionManager *)sessionManager;

-(XLFormDataManager *)formDataManager;


-(void)showActivityIndicator;
-(void)hideActivityIndicator;
-(void)setActivityIndicatorMode:(MRProgressOverlayViewMode)mode;

@property XLFormMode formMode;
@property BOOL showCancelButton;
@property BOOL showSaveButton;
@property BOOL showDeleteButton;


-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtoncaption;
-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtoncaption tableStyle:(UITableViewStyle)style;

@property (weak) id<XLFormViewControllerPresenting> delegate;

-(void)cancelPressed:(UIBarButtonItem *)cancelButton;
-(void)savePressed:(UIBarButtonItem *)saveButton;

@property NSString * deleteButtonCaption;
@property (readonly) UIBarButtonItem * cancelButton;
@property (readonly) UIBarButtonItem * saveButton;
@property (nonatomic) BOOL showNetworkReachability; //Default YES


-(void)showServerErrorMessage:(NSError *)error;

@end


@interface NetworkingFormViewController()

@property (nonatomic)  XLFormDataManager * formDataManager;
-(XLFormDataManager *)createFormDataManager;

@end
