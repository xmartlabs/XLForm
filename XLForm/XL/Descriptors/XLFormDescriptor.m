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
NSString * const XLValidationStatusErrorKey = @"XLValidationStatusErrorKey";

@interface XLFormDescriptor()

@property NSMutableArray * formSections;
@property NSString * title;

@end

@implementation XLFormDescriptor

-(instancetype)init
{
    return [self initWithTitle:nil];
}

-(instancetype)initWithTitle:(NSString *)title;
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

+(instancetype)formDescriptor
{
    return [self formDescriptorWithTitle:nil];
}

+(instancetype)formDescriptorWithTitle:(NSString *)title
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


-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRow:(XLFormRowDescriptor *)beforeRow
{
    NSIndexPath * beforeIndexPath = [self indexPathOfFormRow:beforeRow];
    if (self.formSections.count > beforeIndexPath.section){
        [(self.formSections)[beforeIndexPath.section] addFormRow:formRow beforeRow:beforeRow];
    }
    else{
        [[self.formSections lastObject] addFormRow:formRow beforeRow:beforeRow];
    }
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRowTag:(NSString *)beforeRowTag
{
    XLFormRowDescriptor * beforeRowForm = [self formRowWithTag:beforeRowTag];
    [self addFormRow:formRow beforeRow:beforeRowForm];
}



-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow
{
    NSIndexPath * afterIndexPath = [self indexPathOfFormRow:afterRow];
    if (self.formSections.count > afterIndexPath.section){
        [(self.formSections)[afterIndexPath.section] addFormRow:formRow afterRow:afterRow];
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
    if ((self.formSections.count > indexPath.section) && [(self.formSections)[indexPath.section] formRows].count > indexPath.row){
        return [(self.formSections)[indexPath.section] formRows][indexPath.row];
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
                    result[row.tag] = (row.value ?: [NSNull null]);
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
            result[section.multiValuedTag] = multiValuedValuesArray;
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
                    result[httpParameterKey] = parameterValue;
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
            result[section.multiValuedTag] = multiValuedValuesArray;
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
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: status.msg,
                                            XLValidationStatusErrorKey: status };
                NSError * error = [[NSError alloc] initWithDomain:XLFormErrorDomain code:XLFormErrorCodeGen userInfo:userInfo];
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
        if ([change[NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
            NSIndexSet * indexSet = change[NSKeyValueChangeIndexesKey];
            XLFormSectionDescriptor * section = (self.formSections)[indexSet.firstIndex];
            [self.delegate formSectionHasBeenAdded:section atIndex:indexSet.firstIndex];
        }
        else if ([change[NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
            NSIndexSet * indexSet = change[NSKeyValueChangeIndexesKey];
            XLFormSectionDescriptor * removedSection = change[NSKeyValueChangeOldKey][0];
            [self.delegate formSectionHasBeenRemoved:removedSection atIndex:indexSet.firstIndex];
        }
    }
    else if ([keyPath isEqualToString:@"formRows"]){
        if ([change[NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeInsertion)]){
            NSIndexSet * indexSet = change[NSKeyValueChangeIndexesKey];
            XLFormRowDescriptor * formRow = (((XLFormSectionDescriptor *)object).formRows)[indexSet.firstIndex];
            NSUInteger sectionIndex = [self.formSections indexOfObject:object];
            [self.delegate formRowHasBeenAdded:formRow atIndexPath:[NSIndexPath indexPathForRow:indexSet.firstIndex inSection:sectionIndex]];
        }
        else if ([change[NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeRemoval)]){
            NSIndexSet * indexSet = change[NSKeyValueChangeIndexesKey];
            XLFormRowDescriptor * removedRow = change[NSKeyValueChangeOldKey][0];
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
    return (self.formSections)[index];
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
    XLFormSectionDescriptor * formSection = (self.formSections)[index];
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
