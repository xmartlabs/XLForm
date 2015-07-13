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

#import "XLFormBaseCell.h"

@implementation XLFormBaseCell

- (id)init
{
    return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configure];
}

-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self update];
    [rowDescriptor.cellConfig enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
        [self setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
    if (rowDescriptor.isDisabled){
        [rowDescriptor.cellConfigIfDisabled enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, BOOL * __unused stop) {
            [self setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
        }];
    }
}


- (void)configure
{
}

- (void)update
{
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textLabel.textColor  = self.rowDescriptor.isDisabled ? [UIColor grayColor] : [UIColor blackColor];
}

-(void)highlight
{
}

-(void)unhighlight
{
}

-(XLFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - Navigation Between Fields

-(UIView *)inputAccessoryView
{
    UIView * inputAccessoryView = [self.formViewController inputAccessoryViewForRowDescriptor:self.rowDescriptor];
    if (inputAccessoryView){
        return inputAccessoryView;
    }
    return [super inputAccessoryView];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return NO;
}

#pragma mark -

-(BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result){
        [self.formViewController beginEditing:self.rowDescriptor];
    }
    return result;
}

-(BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if (result){
        [self.formViewController endEditing:self.rowDescriptor];
    }
    return result;
}

@end
