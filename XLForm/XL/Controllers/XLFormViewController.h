//
//  XLFormViewController.h
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

#import <UIKit/UIKit.h>

#import <MRProgress/MRProgress.h>
#import "XLFormDataManager.h"
#import "XLFormOptionsViewController.h"
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormDescriptorDelegate.h"

NSString * const kDeleteButtonTag;

typedef NS_ENUM(NSUInteger, XLFormMode)
{
    XLFormModeCreate = 0,
    XLFormModeEdit,
    XLFormModeDelete
};


@class XLFormViewController;
@class XLFormRowDescriptor;
@class XLFormSectionDescriptor;
@class XLFormDescriptor;

@protocol XLFormViewControllerPresenting <NSObject>

@required

-(void)formViewControllerDidFinish:(XLFormViewController *)formViewController;

@end


@protocol XLFormViewControllerDelegate <NSObject>

@optional


-(AFHTTPSessionManager *)sessionManager;
-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow;
-(NSDictionary *)httpParameters;

-(XLFormDataManager *)formDataManager;
-(void)configureDataManager:(XLFormDataManager *)dataManager;

-(void)showActivityIndicator;
-(void)hideActivityIndicator;
-(void)setActivityIndicatorMode:(MRProgressOverlayViewMode)mode;

-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)section;

-(NSArray *)formValidationErrors;
-(void)showFormValidationError:(NSError *)error;
-(void)showServerError:(NSError *)error;


@end

@interface XLFormViewController : UITableViewController<XLFormDescriptorDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, XLFormViewControllerDelegate, XLDataLoaderDelegate>

@property (weak) id<XLFormViewControllerPresenting> delegate;

@property XLFormDescriptor * form;
@property XLFormMode formMode;
@property BOOL showCancelButton;
@property BOOL showSaveButton;
@property BOOL showDeleteButton;
@property NSString * deleteButtonCaption;
@property (readonly) UIBarButtonItem * cancelButton;
@property (readonly) UIBarButtonItem * saveButton;
@property (nonatomic) BOOL showNetworkReachability; //Default YES

-(id)initWithForm:(XLFormDescriptor *)form;
-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtoncaption;
-(id)initWithForm:(XLFormDescriptor *)form formMode:(XLFormMode)mode showCancelButton:(BOOL)showCancelButton showSaveButton:(BOOL)showSaveButton showDeleteButton:(BOOL)showDeleteButton deleteButtonCaption:(NSString *)deleteButtoncaption tableStyle:(UITableViewStyle)style;

-(void)cancelPressed:(UIBarButtonItem *)cancelButton;
-(void)savePressed:(UIBarButtonItem *)saveButton;

-(NSArray *)formValidationErrors;

+(NSMutableDictionary *)cellClassesForRowDescriptorTypes;

@end

@interface XLFormViewController()

@property (nonatomic)  XLFormDataManager * formDataManager;
-(XLFormDataManager *)createFormDataManager;

@end
