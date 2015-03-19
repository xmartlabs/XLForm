//
//  XLFormTextViewCell.m
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

#import "XLFormRowDescriptor.h"
#import "UIView+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "XLFormTextView.h"
#import "XLFormTextViewCell.h"
#import "XLForm.h"

NSString *const kFormTextViewCellPlaceholder = @"placeholder";
static const CGFloat kPaddingLeft = 16;
static const CGFloat kPaddingRight = 16;
static const CGFloat kKeyboardSpace = 10;


@interface XLFormTextViewCell() <UITextViewDelegate>
@property (nonatomic) UITextView * dummyTextView;
@end

@implementation XLFormTextViewCell
{
    NSMutableArray * _dynamicCustomConstraints;
}

@synthesize textLabel = _textLabel;
@synthesize textView = _textView;
@synthesize dummyTextView = _dummyTextView;

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

-(UITextView *)dummyTextView
{
    if (_dummyTextView) return _dummyTextView;
    _dummyTextView = [[UITextView alloc] init];
    return _dummyTextView;
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
    self.textView.delegate = self;
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.placeHolderLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.text = self.rowDescriptor.value;
    [self.textView setEditable:!self.rowDescriptor.disabled];
    self.textView.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textLabel.textColor = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    
    self.textView.scrollEnabled = [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeTextView];
    
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeTextView]){
        self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title]: self.rowDescriptor.title);
    }
}

-(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    if ([rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeTextView]){
        return ([self.defaultHeight floatValue]) ?: 110.f;
    }
    // Configure the dummy text view
    self.dummyTextView.font = self.textView.font;
    self.dummyTextView.text = rowDescriptor.value ?: @" ";
    
    CGSize textViewSize = [self.dummyTextView sizeThatFits:CGSizeMake(self.contentView.frame.size.width - kPaddingLeft - kPaddingRight, FLT_MAX)];
    CGFloat height = ceilf(textViewSize.height) + 1; // 1 is for contentView height diference on cell
    
    return MAX(height, [self.defaultHeight floatValue]);
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.disabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

-(void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.formViewController.view.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    [self.formViewController reloadFormRow:self.rowDescriptor];
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
        NSDictionary *metrics = @{@"paddingLeft":[NSNumber numberWithFloat:kPaddingLeft],
                                  @"paddingRight":[NSNumber numberWithFloat:kPaddingRight]};
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(paddingLeft)-[textView]-(paddingRight)-|" options:0 metrics:metrics views:views]];
    }
    else{
        [_dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-[textView]-4-|" options:0 metrics:0 views:views]];
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
    
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDynamicTextView]){
        // Update height
        UITableView * tableView  = self.formViewController.tableView;
        [UIView setAnimationsEnabled:NO];
        [tableView beginUpdates];
        [tableView endUpdates];
        [UIView setAnimationsEnabled:YES];
        
        // Scroll
        CGRect cursorRect = [self.textView caretRectForPosition:self.textView.selectedTextRange.end];
        CGRect newRect = CGRectMake(cursorRect.origin.x, cursorRect.origin.y + kKeyboardSpace, cursorRect.size.width, cursorRect.size.height);
        [tableView scrollRectToVisible:[tableView convertRect:newRect fromView:self.textView] animated:NO];
    }
}

@end
