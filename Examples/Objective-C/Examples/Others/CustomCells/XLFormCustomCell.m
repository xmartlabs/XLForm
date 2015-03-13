//
//  XLFormCustomCell.m
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

#import "XLFormCustomCell.h"

@implementation XLFormCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)configure
{
    //override
    UIFont *labelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    UIFontDescriptor *fontDesc = [labelFont fontDescriptor];
    UIFontDescriptor *fontBoldDesc = [fontDesc fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    self.textLabel.font = [UIFont fontWithDescriptor:fontBoldDesc size:0.0f];
}

- (void)update
{
    // override
    self.textLabel.text = @"Am a custom cell, select me!";
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    // custom code here
    // i.e new behaviour when cell has been selected
    self.textLabel.text = @"I can do any custom behaviour...";
    self.rowDescriptor.value = self.textLabel.text;
}

/*
+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    // return custom cell size
    return 40;
}
*/

/*
-(BOOL)formDescriptorCellBecomeFirstResponder
{
    // custom code
    return YES;
}
*/

/*
-(BOOL)formDescriptorCellResignFirstResponder
{
    // custom code
    return YES;
}
*/

/*
-(NSError *)formDescriptorCellLocalValidation
{
    // custom error handler
    // compare with a custom property if it should return a error
    // i.e some textfield is empty etc...
    if (self.rowDescriptor.required){
        return [[NSError alloc] initWithDomain:XLFormErrorDomain code:XLFormErrorCodeRequired userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"%@ can't be empty", nil), self.rowDescriptor.title] }];
        
    }
    return nil;
}
*/

/*
-(NSString *)formDescriptorHttpParameterName 
{
  // custom code
}
*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
