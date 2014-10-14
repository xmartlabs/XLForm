//
//  XLFormDescriptor.m
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


#import "NSObject+XLFormAdditions.h"
#import "XLFormDescriptor.h"

NSString * const XLFormErrorDomain = @"XLFormErrorDomain";

@interface XLFormDescriptor()

@property NSMutableArray * formSections;
@property NSString * title;

@end

@implementation XLFormDescriptor

-(id)init
{
    return [self initWithTitle:nil];
}

-(id)initWithTitle:(NSString *)title;
{
    self = [super init];
    if (self){
        _formSections = [NSMutableArray array];
        _title = title;
        _addAsteriskToRequiredRowsTitle = NO;
        [self addObserver:self forKeyPath:@"formSections" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:0];
    }
    return self;
}

+(XLFormDescriptor *)formDescriptor
{
    return [self formDescriptorWithTitle:nil];
}

+(XLFormDescriptor *)formDescriptorWithTitle:(NSString *)title
{
    return [[XLFormDescriptor alloc] initWithTitle:title];
}

-(void)addFormSection:(XLFormSectionDescriptor *)formSection
{
    [self insertObject:formSection inFormSectionsAtIndex:[self.formSections count]];
}

-(void)addFormSection:(XLFormSectionDescriptor *)formSection atIndex:(NSUInteger)index
{
    if (self.formSections.count >= index) {
        [self insertObject:formSection inFormSectionsAtIndex:index];
    }
}

-(void)addFormSection:(XLFormSectionDescriptor *)formSection afterSection:(XLFormSectionDescriptor *)afterSection
{
    NSUInteger index = [self.formSections indexOfObject:afterSection];
    if (index != NSNotFound) {
        [self insertObject:formSection inFormSectionsAtIndex:[self.formSections indexOfObject:afterSection]+1];
    }
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow
{
    NSIndexPath * afterIndexPath = [self indexPathOfFormRow:afterRow];
    if (self.formSections.count > afterIndexPath.section){
        [[self.formSections objectAtIndex:afterIndexPath.section] addFormRow:formRow afterRow:afterRow];
    }
    else{
        [[self.formSections lastObject] addFormRow:formRow afterRow:afterRow];
    }
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRowTag:(NSString *)afterRowTag
{
    XLFormRowDescriptor * afterRowForm = [self formRowWithTag:afterRowTag];
    [self addFormRow:formRow afterRow:afterRowForm];
}

-(void)removeFormSectionAtIndex:(NSUInteger)index
{
    if (self.formSections.count > index){
        [self removeObjectFromFormSectionsAtIndex:index];
    }
}

-(void)removeFormSection:(XLFormSectionDescriptor *)formSection
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formSections indexOfObject:formSection]) != NSNotFound){
        [self removeFormSectionAtIndex:index];
    };
}

-(void)removeFormRow:(XLFormRowDescriptor *)formRow
{
    for (XLFormSectionDescriptor * section in self.formSections){
        if ([section.formRows containsObject:formRow]){
            [section removeFormRow:formRow];
        }
    }
}


-(XLFormRowDescriptor *)formRowWithTag:(NSString *)tag
{
    for (XLFormSectionDescriptor * section in self.formSections){
        for (XLFormRowDescriptor * row in section.formRows) {
            if ([row.tag isEqualToString:tag]){
                return row;
            }
        }
    }
    return nil;
}

-(XLFormRowDescriptor *)formRowWithHash:(NSUInteger)hash
{
    for (XLFormSectionDescriptor * section in self.formSections){
        for (XLFormRowDescriptor * row in section.formRows) {
            if ([row hash] == hash){
                return row;
            }
        }
    }
    return nil;
}


-(void)removeFormRowWithTag:(NSString *)tag
{
    XLFormRowDescriptor * formRow = [self formRowWithTag:tag];
    [self removeFormRow:formRow];
}

-(XLFormRowDescriptor *)formRowAtIndex:(NSIndexPath *)indexPath
{
    if ((self.formSections.count > indexPath.section) && [[self.formSections objectAtIndex:indexPath.section] formRows].count > indexPath.row){
        return [[[self.formSections objectAtIndex:indexPath.section] formRows] objectAtIndex:indexPath.row];
    }
    return nil;
}

-(XLFormSectionDescriptor *)formSectionAtIndex:(NSUInteger)index
{
    return [self objectInFormSectionsAtIndex:index];
}

-(NSIndexPath *)indexPathOfFormRow:(XLFormRowDescriptor *)formRow
{
    for (XLFormSectionDescriptor * section in self.formSections){
        for (XLFormRowDescriptor * row in section.formRows) {
            if (row == formRow){
                return [NSIndexPath indexPathForRow:[section.formRows indexOfObject:formRow] inSection:[self.formSections indexOfObject:section]];
            }
        }
    }
    return nil;
}

-(NSDictionary *)formValues
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (XLFormSectionDescriptor * section in self.formSections) {
        if (!section.isMultivaluedSection)
        {
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.tag && ![row.tag isEqualToString:@""]){
                    [result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
                }
            }
        }
        else{
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (XLFormRowDescriptor * row in section.formRows) {
                if (row.value){
                    [multiValuedValuesArray addObject:row.value];
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multiValuedTag];
        }
    }
    return result;
    
}

-(NSDictionary *)httpParameters:(XLFormViewController *)formViewController
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    for (XLFormSectionDescriptor * section in self.formSections) {
        if (!section.isMultivaluedSection)
        {
            for (XLFormRowDescriptor * row in section.formRows) {
                NSString * httpParameterKey = nil;
                if ((httpParameterKey = [self httpParameterKeyForRow:row cell:[row cellForFormController:formViewController]])){
                    id parameterValue = [row.value valueData] ?: [NSNull null];
                    [result setObject:parameterValue forKey:httpParameterKey];
                }
            }
        }
        else{
            NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
            for (XLFormRowDescriptor * row in section.formRows) {
                if ([row.value valueData]){
                    [multiValuedValuesArray addObject:[row.value valueData]];
                }
            }
            [result setObject:multiValuedValuesArray forKey:section.multiValuedTag];
        }
    }
    return result;
}

-(NSString *)httpParameterKeyForRow:(XLFormRowDescriptor *)row cell:(UITableViewCell<XLFormDescriptorCell> *)descriptorCell
{
    if ([descriptorCell respondsToSelector:@selector(formDescriptorHttpParameterName)]){
        return [descriptorCell formDescriptorHttpParameterName];
    }
    if (row.tag && ![row.tag isEqualToString:@""]){
        return row.tag;
    }
    return nil;
}

-(NSArray *)localValidationErrors:(XLFormViewController *)formViewController {
    NSMutableArray * result = [NSMutableArray array];
    for (XLFormSectionDescriptor * section in self.formSections) {
        for (XLFormRowDescriptor * row in section.formRows) {
            XLFormValidationStatus* status = [row doValidation];
            if (status != nil && (![status isValid])) {
                NSError * error = [[NSError alloc] initWithDomain:XLFormErrorDomain code:XLFormErrorCodeGen userInfo:@{ NSLocalizedDescriptionKey:status.msg }];
                if (error){
                    [result addObject:error];
                }
            }
        }
    }
    
    return result;
}


- (void)setFirstResponder:(XLFormViewController *)formViewController
{
    for (XLFormSectionDescriptor * formSection in self.formSections) {
        for (XLFormRowDescriptor * row in formSection.formRows) {
            UITableViewCell<XLFormDescriptorCell> * cell = [row cellForFormController:formViewController];
            if ([cell respondsToSelector:@selector(formDescriptorCellBecomeFirstResponder)]){
                if ([cell formDescriptorCellBecomeFirstResponder]){
                    return;
                }
            }
        }
    }
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.delegate) return;
    if ([keyPath isEqualToString:@"formSections"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            XLFormSectionDescriptor * section = [self.formSections objectAtIndex:indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            XLFormSectionDescriptor * removedSection = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
            [self.delegate formSectionHasBeenRemoved:removedSection atIndex:indexSet.firstIndex];
        }
    }
    else if ([keyPath isEqualToString:@"formRows"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            XLFormRowDescriptor * formRow = [((XLFormSectionDescriptor *)object).formRows objectAtIndex:indexSet.firstIndex];
            NSUInteger sectionIndex = [self.formSections indexOfObject:object];
            [self.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
        }
        else if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            XLFormRowDescriptor * removedRow = [[change objectForKey:NSKeyValueChangeOldKey] objectAtIndex:0];
            NSUInteger sectionIndex = [self.formSections indexOfObject:object];
            [self.delegate formRowHasBeenRemoved:removedRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
        }
        
    }
}

-(void)dealloc
{
    for (XLFormSectionDescriptor * formSection in self.formSections) {
        @try {
            [formSection removeObserver:self forKeyPath:@"formRows"];
        }
        @catch (NSException * __unused exception) {}
    }
    @try {
        [self removeObserver:self forKeyPath:@"formSections"];
    }
    @catch (NSException * __unused exception) {}
}

#pragma mark - KVC

-(NSUInteger)countOfFormSections
{
    return self.formSections.count;
}

- (id)objectInFormSectionsAtIndex:(NSUInteger)index {
    return [self.formSections objectAtIndex:index];
}

- (NSArray *)formSectionsAtIndexes:(NSIndexSet *)indexes {
    return [self.formSections objectsAtIndexes:indexes];
}

- (void)insertObject:(XLFormSectionDescriptor *)formSection inFormSectionsAtIndex:(NSUInteger)index {
    formSection.formDescriptor = self;
    [formSection addObserver:self forKeyPath:@"formRows" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:0];
    [self.formSections insertObject:formSection atIndex:index];
}

- (void)removeObjectFromFormSectionsAtIndex:(NSUInteger)index {
    XLFormSectionDescriptor * formSection = [self.formSections objectAtIndex:index];
    @try {
        [formSection removeObserver:self forKeyPath:@"formRows"];
    }
    @catch (NSException * __unused exception) {}
    [self.formSections removeObjectAtIndex:index];
}


#pragma mark - private

-(NSMutableArray *)formSections
{
    return _formSections;
}


@end
