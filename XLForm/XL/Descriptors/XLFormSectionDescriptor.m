//
//  XLFormSectionDescriptor.m
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

#import "XLFormSectionDescriptor.h"

@interface XLFormSectionDescriptor()

@property NSMutableArray * formRows;

@end

@implementation XLFormSectionDescriptor

-(id)init
{
    self = [super init];
    if (self){
        _formRows = [NSMutableArray array];
        _isMultivaluedSection = NO;
        _title = nil;
        _footerTitle = nil;
    }
    return self;
}


-(id)initWithTitle:(NSString *)title multivaluedSection:(BOOL)multivaluedSection
{
    self = [self init];
    if (self){
        _isMultivaluedSection = multivaluedSection;
        _title = title;
    }
    return self;
}

+(id)formSection
{
    return [self formSectionWithTitle:nil];
}

+(id)formSectionWithTitle:(NSString *)title
{
    return [self formSectionWithTitle:title multivaluedSection:NO];
}

+(id)formSectionWithTitle:(NSString *)title multivaluedSection:(BOOL)multivaluedSection
{
    return [[XLFormSectionDescriptor alloc] initWithTitle:title multivaluedSection:multivaluedSection];
}

-(XLFormRowDescriptor *)newMultivaluedFormRowDescriptor
{
    XLFormRowDescriptor * formRowDescriptor = [[self.formRows objectAtIndex:0] copy];
    formRowDescriptor.tag = nil;
    return formRowDescriptor;
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow
{
    [self insertObject:formRow inFormRowsAtIndex:[self.formRows count]];
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow
{
    NSUInteger index;
    if ((index =  [self.formRows indexOfObject:afterRow]) != NSNotFound){
        [self insertObject:formRow inFormRowsAtIndex:index + 1];
    }
    else {
        [self addFormRow:formRow];
    }
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRow:(XLFormRowDescriptor *)beforeRow
{
    NSUInteger index;
    if ((index =  [self.formRows indexOfObject:beforeRow]) != NSNotFound){
        [self insertObject:formRow inFormRowsAtIndex:index];
    }
    else {
        [self addFormRow:formRow];
    }
}


-(void)removeFormRowAtIndex:(NSUInteger)index
{
    if (self.formRows.count > index){
        [self removeObjectFromFormRowsAtIndex:index];
    }
}

-(void)removeFormRow:(XLFormRowDescriptor *)formRow
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formRows indexOfObject:formRow]) != NSNotFound){
        [self removeFormRowAtIndex:index];
    };
}

-(NSUInteger)indexOfFormRow:(XLFormRowDescriptor*)formRow
{
    return [self.formRows indexOfObject:formRow];
}

-(void)dealloc
{
    for (XLFormRowDescriptor * formRow in self.formRows) {
        @try {
            [formRow removeObserver:self forKeyPath:@"value"];
        }
        @catch (NSException * __unused exception) {}
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[XLFormRowDescriptor class]] && [keyPath isEqualToString:@"value"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            [self.formDescriptor.delegate formRowDescriptorValueHasChanged:object oldValue:oldValue newValue:newValue];
        }
    }
}



#pragma mark - KVC

-(NSUInteger)countOfFormRows
{
    return self.formRows.count;
}

- (id)objectInFormRowsAtIndex:(NSUInteger)index {
    return [self.formRows objectAtIndex:index];
}

- (NSArray *)formRowsAtIndexes:(NSIndexSet *)indexes {
    return [self.formRows objectsAtIndexes:indexes];
}

- (void)insertObject:(XLFormRowDescriptor *)formRow inFormRowsAtIndex:(NSUInteger)index {
    formRow.sectionDescriptor = self;
    [formRow addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.formRows insertObject:formRow atIndex:index];
}

- (void)removeObjectFromFormRowsAtIndex:(NSUInteger)index {
    XLFormRowDescriptor * formRow = [self.formRows objectAtIndex:index];
    @try {
        [formRow removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException * __unused exception) {}
    [self.formRows removeObjectAtIndex:index];
}




@end
