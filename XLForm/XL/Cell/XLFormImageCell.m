//
//  XLFormBaseCell.m
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

#import "XLFormImageCell.h"
#import "XLFormRowDescriptor.h"
#import "UIView+XLFormAdditions.h"

@interface XLFormImageCell() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIPopoverController *popoverController;
    UIImagePickerController *imagePickerController;
    UIAlertController *alertController;
}

@end

@implementation XLFormImageCell

#pragma mark - XLFormDescriptorCell
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 40;
}

- (void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.editingAccessoryView = self.accessoryView;
}

- (void)update
{
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.imageView.image = self.rowDescriptor.value;
}

- (void)chooseImage:(UIImage *)image
{
    self.imageView.image = image;
    self.rowDescriptor.value = image;
}

- (UIImageView *)imageView
{
    return (UIImageView *)self.accessoryView;
}

- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    alertController = [UIAlertController alertControllerWithTitle: self.rowDescriptor.title
                                                          message: nil
                                                   preferredStyle: UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Choose From Library", nil)
                                                        style: UIAlertActionStyleDefault
                                                      handler: ^(UIAlertAction * _Nonnull action) {
                                                          [self openImage:UIImagePickerControllerSourceTypePhotoLibrary];
                                                      }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Take Photo", nil)
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction * _Nonnull action) {
                                                              [self openImage:UIImagePickerControllerSourceTypeCamera];
                                                          }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel", nil)
                                                        style: UIAlertActionStyleCancel
                                                      handler: nil]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceView = self.contentView;
        alertController.popoverPresentationController.sourceRect = self.contentView.bounds;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.formViewController presentViewController:alertController animated: true completion: nil];
    });
}

- (void)openImage:(UIImagePickerControllerSourceType)source
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = source;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        [popoverController presentPopoverFromRect: self.contentView.frame
                                           inView: self.formViewController.view
                         permittedArrowDirections: UIPopoverArrowDirectionAny
                                         animated: YES];
    } else {
        [self.formViewController presentViewController: imagePickerController
                                              animated: YES
                                            completion: nil];
    }
}

#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        [self chooseImage:editedImage];
    } else {
        [self chooseImage:originalImage];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (popoverController && popoverController.isPopoverVisible) {
            [popoverController dismissPopoverAnimated: YES];
        }
    } else {
        [self.formViewController dismissViewControllerAnimated: YES completion: nil];
    }
}

@end
