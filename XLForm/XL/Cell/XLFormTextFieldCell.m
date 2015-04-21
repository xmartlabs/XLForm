//
//  XLFormTextFieldCell.m
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

#import "NSObject+XLFormAdditions.h"
#import "UIView+XLFormAdditions.h"
#import "XLFormRowDescriptor.h"
#import "XLForm.h"
#import "XLFormTextFieldCell.h"

@interface XLFormTextFieldCell() <UITextFieldDelegate>

@property NSArray * dynamicCustomConstraints;
@property UIReturnKeyType returnKeyType;

@end

@implementation XLFormTextFieldCell

@synthesize textField = _textField;
@synthesize textLabel = _textLabel;


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"]) ||  (object == self.imageView && [keyPath isEqualToString:@"image"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeText]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeName]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.textField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeEmail]){
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber]){
        self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInteger]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDecimal]){
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypePassword]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.secureTextEntry = YES;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypePhone]){
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeURL]){
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.keyboardType = UIKeyboardTypeURL;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeTwitter]){
        self.textField.keyboardType = UIKeyboardTypeTwitter;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeAccount]){
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title] : self.rowDescriptor.title);
    
    self.textField.text = self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText;
    [self.textField setEnabled:!self.rowDescriptor.isDisabled];
    self.textField.textColor = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
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

#pragma mark - Properties

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}

-(UITextField *)textField
{
    if (_textField) return _textField;
    _textField = [UITextField autolayoutView];
    return _textField;
}

#pragma mark - LayoutConstraints

-(NSArray *)layoutConstraints
{
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textField]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textLabel]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    return result;
}

-(void)updateConstraints
{
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
    NSDictionary * views = @{@"label": self.textLabel, @"textField": self.textField, @"image": self.imageView};
    NSDictionary *metrics = @{@"leftMargin" : @16.0, @"rightMargin" : self.textField.textAlignment == NSTextAlignmentRight ? @16.0 : @4.0};

    if (self.imageView.image){
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[label]-[textField]-(rightMargin)-|" options:0 metrics:metrics views:views];
        }
        else{
            self.dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-[textField]-(rightMargin)-|" options:0 metrics:metrics views:views];
        }
    }
    else{
        if (self.textLabel.text.length > 0){
            self.dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftMargin)-[label]-[textField]-(rightMargin)-|" options:0 metrics:metrics views:views];
        }
        else{
            self.dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftMargin)-[textField]-(rightMargin)-|" options:0 metrics:metrics views:views];
        }
    }
    [self.contentView addConstraints:self.dynamicCustomConstraints];
    [super updateConstraints];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formViewController beginEditing:self.rowDescriptor];
    [self.formViewController textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textFieldDidEndEditing:textField];
}


#pragma mark - Helper

- (void)textFieldDidChange:(UITextField *)textField{
    if([self.textField.text length] > 0) {
        if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDecimal]){
            self.rowDescriptor.value =  @([self.textField.text doubleValue]);
        } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInteger]){
            self.rowDescriptor.value = @([self.textField.text integerValue]);
        } else {
            self.rowDescriptor.value = self.textField.text;
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    self.textField.returnKeyType = returnKeyType;
}

-(UIReturnKeyType)returnKeyType
{
    return self.textField.returnKeyType;
}

@end
