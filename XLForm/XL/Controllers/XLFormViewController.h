//
//  XLFormViewController.h
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

#import <UIKit/UIKit.h>
#import "XLFormOptionsViewController.h"
#import "XLFormDescriptor.h"
#import "XLFormSectionDescriptor.h"
#import "XLFormDescriptorDelegate.h"
#import "XLFormRowNavigationAccessoryView.h"
#import "XLFormBaseCell.h"

@class XLFormViewController;
@class XLFormRowDescriptor;
@class XLFormSectionDescriptor;
@class XLFormDescriptor;
@class XLFormBaseCell;

typedef NS_ENUM(NSUInteger, XLFormRowNavigationDirection) {
    XLFormRowNavigationDirectionPrevious = 0,
    XLFormRowNavigationDirectionNext
};

@protocol XLFormViewControllerDelegate <NSObject>

@optional

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow;
-(void)deselectFormRow:(XLFormRowDescriptor *)formRow;
-(void)reloadFormRow:(XLFormRowDescriptor *)formRow;
-(XLFormBaseCell *)updateFormRow:(XLFormRowDescriptor *)formRow;

-(NSDictionary *)formValues;
-(NSDictionary *)httpParameters;

-(XLFormRowDescriptor *)formRowFormMultivaluedFormSection:(XLFormSectionDescriptor *)formSection;
-(void)multivaluedInsertButtonTapped:(XLFormRowDescriptor *)formRow;
-(UIStoryboard *)storyboardForRow:(XLFormRowDescriptor *)formRow;

-(NSArray *)formValidationErrors;
-(void)showFormValidationError:(NSError *)error;

-(UITableViewRowAnimation)insertRowAnimationForRow:(XLFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)deleteRowAnimationForRow:(XLFormRowDescriptor *)formRow;
-(UITableViewRowAnimation)insertRowAnimationForSection:(XLFormSectionDescriptor *)formSection;
-(UITableViewRowAnimation)deleteRowAnimationForSection:(XLFormSectionDescriptor *)formSection;

// InputAccessoryView
-(UIView *)inputAccessoryViewForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor;
-(XLFormRowDescriptor *)nextRowDescriptorForRow:(XLFormRowDescriptor*)currentRow withDirection:(XLFormRowNavigationDirection)direction;

// highlight/unhighlight
-(void)beginEditing:(XLFormRowDescriptor *)rowDescriptor;
-(void)endEditing:(XLFormRowDescriptor *)rowDescriptor;

-(void)ensureRowIsVisible:(XLFormRowDescriptor *)inlineRowDescriptor;

@end

@interface XLFormViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, XLFormDescriptorDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, XLFormViewControllerDelegate>

@property XLFormDescriptor * form;
@property IBOutlet UITableView * tableView;

-(instancetype)initWithForm:(XLFormDescriptor *)form;
-(instancetype)initWithForm:(XLFormDescriptor *)form style:(UITableViewStyle)style;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;
+(NSMutableDictionary *)cellClassesForRowDescriptorTypes;
+(NSMutableDictionary *)inlineRowDescriptorTypesForRowDescriptorTypes;

-(void)performFormSelector:(SEL)selector withObject:(id)sender;

@end
