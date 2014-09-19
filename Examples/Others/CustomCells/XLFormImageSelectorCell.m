//
//  XLFormImageSelectorCell.m
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

#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+XLFormAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "XLFormImageSelectorCell.h"


NSString *const kFormImageSelectorCellDefaultImage = @"defaultImage";
NSString *const kFormImageSelectorCellImageRequest = @"imageRequest";

@interface XLFormImageSelectorCell() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImage * defaultImage;
@property (nonatomic) NSURLRequest * imageRequest;

@end

@implementation XLFormImageSelectorCell{
    CGFloat _imageHeight;
    CGFloat _imageWidth;
}
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;


#pragma mark - XLFormDescriptorCell


- (void)configure
{
    [super configure];
    _imageHeight = 100.0f;
    _imageWidth = 100.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.separatorInset = UIEdgeInsetsZero;
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self addLayoutConstraints];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];

}

- (void)update
{
    self.textLabel.text = self.rowDescriptor.title;
    self.imageView.image = self.rowDescriptor.value ?: self.defaultImage;
    if (self.imageRequest && !self.rowDescriptor.value){
        __weak __typeof(self) weakSelf = self;
        [self.imageView setImageWithURLRequest:self.imageRequest
                                   placeholderImage:self.defaultImage
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                if (!weakSelf.rowDescriptor.value && image){
                                                    [weakSelf.imageView setImage:image];
                                                }
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                NSLog(@"Failed to download image");
                                            }];
    }
    [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
}


+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 120.0f;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    if (self.formViewController.readOnlyMode) {
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.rowDescriptor.selectorTitle delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"XLFormImageSelectorCell_ChooseExistingPhoto", @"Choose Existing Photo"), NSLocalizedString(@"XLFormImageSelectorCell_TakePicture", @"Take a Picture"), nil];
    actionSheet.tag = self.tag;
    [actionSheet showInView:self.formViewController.view];
}

#pragma mark - LayoutConstraints

-(void)addLayoutConstraints
{
    NSDictionary *uiComponents = @{ @"image" : self.imageView,
                                    @"text"  : self.textLabel};

    NSDictionary *metrics = @{@"margin":@5.0};

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[text]" options:0 metrics:metrics views:uiComponents]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[text]" options:0 metrics:metrics views:uiComponents]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:10.0f]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f
                                                                  constant:-10.0f]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(width)]" options:0 metrics:@{ @"width" : @(_imageWidth) } views:uiComponents]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0f
                                                                           constant:0.0f]];
}


-(void)setImageValue:(UIImage *)image
{
    self.rowDescriptor.value = image;
    self.imageView.image = image;
}

-(void)updateConstraints
{

    [super updateConstraints];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView needsUpdateConstraints];
        }
    }
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 0){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        [self.formViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        [self.formViewController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        // ensure the user has taken a picture
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        }
        else {
            imageToUse = originalImage;
        }
        [self setImageValue:imageToUse];
    }

    [self.formViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Properties

-(UIImageView *)imageView
{
    if (_imageView) return _imageView;
    _imageView = [UIImageView autolayoutView];
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.cornerRadius = _imageHeight / 2.0;
    return _imageView;
}

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}


-(void)setDefaultImage:(UIImage *)defaultImage
{
    _defaultImage = defaultImage;
}


-(void)setImageRequest:(NSURLRequest *)imageRequest
{
    _imageRequest = imageRequest;
}


@end
