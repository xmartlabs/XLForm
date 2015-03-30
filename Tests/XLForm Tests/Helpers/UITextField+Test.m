//
//  UITextField+Test.m
//  XLForm Tests
//
//  Created by Gaston Borba on 3/25/15.
//
//

#import "UITextField+Test.h"

@implementation UITextField (Test)

- (void)beginEditing
{
    [self becomeFirstResponder]; // Returns NO ?
    
    if ([self textFieldShouldBeginEditing]){
        if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
            [self.delegate textFieldDidBeginEditing:self];
        }
    }
}

- (void)endEditing
{
    if ([self textFieldShouldReturn]) {
        if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [self.delegate textFieldDidEndEditing:self];
        }
        [self resignFirstResponder];
    }
}


-(BOOL)textFieldShouldReturn
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:self];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
       return [self.delegate textFieldShouldBeginEditing:self];
    }
    return YES;
}

-(void)changeText:(NSString *)string
{
    [self beginEditing];
    [self setText:string];
    [self endEditing];
}

@end
