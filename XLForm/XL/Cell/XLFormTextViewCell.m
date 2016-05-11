//
//  XLFormTextViewCell.m
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

#import "XLFormRowDescriptor.h"
#import "UIView+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "XLFormTextView.h"
#import "XLFormTextViewCell.h"

NSString *const kFormTextViewCellPlaceholder = @"placeholder";
NSString *const XLFormTextViewLengthPercentage = @"textViewLengthPercentage";

@interface XLFormTextViewCell() <UITextViewDelegate>

@end

@implementation XLFormTextViewCell
{
    NSMutableArray * _dynamicCustomConstraints;
}

@synthesize textLabel = _textLabel;
@synthesize textView = _textView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dynamicCustomConstraints = [NSMutableArray array];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self needsUpdateConstraints];
        }
    }
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}


#pragma mark - Properties

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    [_textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    return _textLabel;
}

-(UILabel *)label
{
    return self.textLabel;
}

-(XLFormTextView *)textView
{
    if (_textView) return _textView;
    _textView = [XLFormTextView autolayoutView];
    return _textView;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textView];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    NSDictionary * views = @{@"label": self.textLabel, @"textView": self.textView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]" options:0 metrics:0 views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[textView]-0-|" options:0 metrics:0 views:views]];
}

-(void)update
{
    [super update];
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.placeHolderLabel.font = self.textView.font;
    self.textView.delegate = self;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.text = self.rowDescriptor.value;
    [self.textView setEditable:!self.rowDescriptor.isDisabled];
    self.textView.textColor  = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title]: self.rowDescriptor.title);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 110.f;
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

-(void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    [self.formViewController updateFormRow:self.rowDescriptor];
}

#pragma mark - Constraints

-(void)updateConstraints
{
    if (_dynamicCustomConstraints){
        [self.contentView removeConstraints:_dynamicCustomConstraints];
        [_dynamicCustomConstraints removeAllObjects];
    }
    NSDictionary * views = @{@"label": self.textLabel, @"textView": self.textView};
    if (!self.textLabel.text || [self.textLabel.text isEqualToString:@""]){
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:0 views:views]];
    }
    else{
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textView]-|" options:0 metrics:0 views:views]];
        if (self.textViewLengthPercentage) {
            [_dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:_textView
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeWidth
                                                                             multiplier:[self.textViewLengthPercentage floatValue]
                                                                               constant:0.0]];
        }
    }
    [self.contentView addConstraints:_dynamicCustomConstraints];
    [super updateConstraints];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.formViewController beginEditing:self.rowDescriptor];
    return [self.formViewController textViewDidBeginEditing:textView];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text length] > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textViewDidEndEditing:textView];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return [self.formViewController textViewShouldBeginEditing:textView];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([self.textView.text length] > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return [self.formViewController textView:textView shouldChangeTextInRange:range replacementText:text];
}

@end
