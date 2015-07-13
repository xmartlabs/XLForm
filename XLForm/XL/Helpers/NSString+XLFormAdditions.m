//
//  NSString+XLFormAdditions.m
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

#import "NSString+XLFormAdditions.h"

@implementation NSString (XLFormAdditions)

-(NSPredicate *)formPredicate
{
    // returns an array of strings where the first one is the new string with the correct replacements
    // and the rest are all the tags that appear in the string
    NSString* separator = @"$";
    
    NSArray* tokens = [self componentsSeparatedByString:separator];
    NSMutableString* new_string = [[NSMutableString alloc] initWithString:tokens[0]];
    NSRange range;
    for (int i = 1; i < tokens.count; i++) {
        [new_string appendString:separator];
        NSArray* subtokens = [[tokens[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>!=+-&|"]][0]
                              componentsSeparatedByString:@"."];
        NSString* tag = subtokens[0];
        NSString* attribute;
        if ([subtokens count] >= 2) {
            attribute = subtokens[1];
        }
        [new_string appendString:tag];
        range = [tokens[i] rangeOfString:[NSString stringWithFormat:@"%@", tag]];
        if (!attribute || (![attribute isEqualToString:@"value"] && ![attribute isEqualToString:@"isHidden"] && ![attribute isEqualToString:@"isDisabled"])){
            [new_string appendString:@".value"];
        }
        [new_string appendString:[tokens[i] substringFromIndex:range.location + range.length]];
    }
    return [NSPredicate predicateWithFormat:new_string];

}


-(NSString *)formKeyForPredicateType:(XLPredicateType)predicateType
{
    return [NSString stringWithFormat:@"%@-%@", self, (predicateType == XLPredicateTypeHidden ? @"hidden" : @"disabled") ];
}

@end
