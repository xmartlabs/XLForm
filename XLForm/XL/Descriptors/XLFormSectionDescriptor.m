//
//  XLFormSectionDescriptor.m
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

#import "XLForm.h"
#import "XLFormSectionDescriptor.h"
#import "NSPredicate+XLFormAdditions.h"
#import "NSString+XLFormAdditions.h"


@interface XLFormDescriptor (_XLFormSectionDescriptor)

@property (readonly) NSMutableDictionary* allRowsByTag;

-(void)addRowToTagCollection:(XLFormRowDescriptor*)rowDescriptor;
-(void)removeRowFromTagCollection:(XLFormRowDescriptor*) rowDescriptor;
-(void)showFormSection:(XLFormSectionDescriptor*)formSection;
-(void)hideFormSection:(XLFormSectionDescriptor*)formSection;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;

@end

@interface XLFormSectionDescriptor()

@property NSMutableArray * formRows;
@property NSMutableArray * allRows;
@property (nonatomic) NSNumber * hidePredicateCache;

@end

@implementation XLFormSectionDescriptor

@synthesize hidden = _hidden;

-(id)init
{
    self = [super init];
    if (self){
        _formRows = [NSMutableArray array];
        _allRows = [NSMutableArray array];
        _sectionInsertMode = XLFormSectionInsertModeLastRow;
        _sectionOptions = XLFormSectionOptionNone;
        _title = nil;
        _footerTitle = nil;
        _hidden = @NO;
        _hidePredicateCache = nil;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title sectionOptions:(XLFormSectionOptions)sectionOptions sectionInsertMode:(XLFormSectionInsertMode)sectionInsertMode{
    self = [self init];
    if (self){
        _sectionInsertMode = sectionInsertMode;
        _sectionOptions = sectionOptions;
        _title = title;
        if ([self canInsertUsingButton]){
            _multivaluedAddButton = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Add Item"];
            [_multivaluedAddButton.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
            [_multivaluedAddButton.cellConfig setObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forKey:@"textLabel.textColor"];
            _multivaluedAddButton.action.formSelector = NSSelectorFromString(@"multivaluedInsertButtonTapped:");
            [self insertObject:_multivaluedAddButton inFormRowsAtIndex:0];
            [self insertObject:_multivaluedAddButton inAllRowsAtIndex:0];
        }
    }
    return self;
}

+(id)formSection
{
    return [self formSectionWithTitle:nil];
}

+(id)formSectionWithTitle:(NSString *)title
{
    return [self formSectionWithTitle:title sectionOptions:XLFormSectionOptionNone];
}

+(id)formSectionWithTitle:(NSString *)title multivaluedSection:(BOOL)multivaluedSection
{
    return [self formSectionWithTitle:title sectionOptions:(multivaluedSection ? XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete : XLFormSectionOptionNone)];
}

+(id)formSectionWithTitle:(NSString *)title sectionOptions:(XLFormSectionOptions)sectionOptions
{
    return [self formSectionWithTitle:title sectionOptions:sectionOptions sectionInsertMode:XLFormSectionInsertModeLastRow];
}

+(id)formSectionWithTitle:(NSString *)title sectionOptions:(XLFormSectionOptions)sectionOptions sectionInsertMode:(XLFormSectionInsertMode)sectionInsertMode
{
    return [[XLFormSectionDescriptor alloc] initWithTitle:title sectionOptions:sectionOptions sectionInsertMode:sectionInsertMode];
}

-(BOOL)isMultivaluedSection
{
    return (self.sectionOptions != XLFormSectionOptionNone);
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow
{
//    if (![[formRow isHidden] boolValue]){
//        [self insertObject:formRow inFormRowsAtIndex:([self canInsertUsingButton] ? MAX(0, [self.formRows count] - 1) : [self.formRows count])];
//    }
    [self insertObject:formRow inAllRowsAtIndex:([self canInsertUsingButton] ? MAX(0, [self.formRows count] - 1) : [self.allRows count])];
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow afterRow:(XLFormRowDescriptor *)afterRow
{
    NSUInteger allRowIndex = [self.allRows indexOfObject:afterRow];
    if (allRowIndex != NSNotFound) {
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex+1];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
//    
//    if (![formRow.isHidden boolValue]){
//        NSUInteger index = [self.formRows indexOfObject:afterRow];
//        while (index == NSNotFound && allRowIndex != 0) {
//            afterRow = [self.allRows objectAtIndex:(--allRowIndex)];
//            index = [self.formRows indexOfObject:afterRow];
//        }
//        if (index != NSNotFound) {
//            [self insertObject:formRow inFormRowsAtIndex:index+1];
//        }
//        else { // insert at the beginning as there is no previous row
//            [self insertObject:formRow inFormRowsAtIndex:0];
//        }
//    }
}

-(void)addFormRow:(XLFormRowDescriptor *)formRow beforeRow:(XLFormRowDescriptor *)beforeRow
{
    
    NSUInteger allRowIndex = [self.allRows indexOfObject:beforeRow];
    if (allRowIndex != NSNotFound) {
        [self.formDescriptor addRowToTagCollection:formRow];
        [self insertObject:formRow inAllRowsAtIndex:allRowIndex];
    }
    else { //case when afterRow does not exist. Just insert at the end.
        [self addFormRow:formRow];
        return;
    }
    
//    if (![[formRow isHidden] boolValue]){
//        NSUInteger index = [self.formRows indexOfObject:beforeRow];
//        while (index == NSNotFound && allRowIndex != ([self.allRows count]-1)) {
//            beforeRow = [self.allRows objectAtIndex:(++allRowIndex)];
//            index = [self.formRows indexOfObject:beforeRow];
//        }
//        if (index != NSNotFound) {
//            [self insertObject:formRow inFormRowsAtIndex:index];
//        }
//        else { // insert at the end as there is no row after this
//            [self insertObject:formRow inFormRowsAtIndex:[self.formRows count]];
//        }
//    }
}

-(void)removeFormRowAtIndex:(NSUInteger)index
{
    if (self.formRows.count > index){
        XLFormRowDescriptor *formRow = [self.formRows objectAtIndex:index];
        NSUInteger allRowIndex = [self.allRows indexOfObject:formRow];
        [self removeObjectFromFormRowsAtIndex:index];
        [self removeObjectFromAllRowsAtIndex:allRowIndex];
    }
}

-(void)removeFormRow:(XLFormRowDescriptor *)formRow
{
    NSUInteger index = NSNotFound;
    if ((index = [self.formRows indexOfObject:formRow]) != NSNotFound){
        [self removeFormRowAtIndex:index];
    }
    else if ((index = [self.allRows indexOfObject:formRow]) != NSNotFound){
        if (self.allRows.count > index){
            [self removeObjectFromAllRowsAtIndex:index];
        }
    };
}

- (void)moveRowAtIndexPath:(NSIndexPath *)sourceIndex toIndexPath:(NSIndexPath *)destinationIndex
{
    if ((sourceIndex.row < self.formRows.count) && (destinationIndex.row < self.formRows.count) && (sourceIndex.row != destinationIndex.row)){
        XLFormRowDescriptor * row = [self objectInFormRowsAtIndex:sourceIndex.row];
        XLFormRowDescriptor * destRow = [self objectInFormRowsAtIndex:destinationIndex.row];
        [self.formRows removeObjectAtIndex:sourceIndex.row];
        [self.formRows insertObject:row atIndex:destinationIndex.row];
        
        [self.allRows removeObjectAtIndex:[self.allRows indexOfObject:row]];
        [self.allRows insertObject:row atIndex:[self.allRows indexOfObject:destRow]];
    }
}

-(void)dealloc
{
    for (XLFormRowDescriptor * formRow in self.formRows) {
        @try {
            [formRow removeObserver:self forKeyPath:@"value"];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [formRow removeObserver:self forKeyPath:@"disablePredicateCache"];
        }
        @catch (NSException * __unused exception) {}
        @try {
            [formRow removeObserver:self forKeyPath:@"hidePredicateCache"];
        }
        @catch (NSException * __unused exception) {}
    }
    [self.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeHidden];
}

#pragma mark - Show/hide rows

-(void)showFormRow:(XLFormRowDescriptor*)formRow{
    
    NSUInteger formIndex = [self.formRows indexOfObject:formRow];
    if (formIndex != NSNotFound) {
        return;
    }
    NSUInteger index = [self.allRows indexOfObject:formRow];
    if (index != NSNotFound){
        while (formIndex == NSNotFound && index > 0) {
            XLFormRowDescriptor* previous = [self.allRows objectAtIndex:--index];
            formIndex = [self.formRows indexOfObject:previous];
        }
        if (formIndex == NSNotFound){ // index == 0 => insert at the beginning
            [self insertObject:formRow inFormRowsAtIndex:0];
        }
        else {
            [self insertObject:formRow inFormRowsAtIndex:formIndex+1];
        }
        
    }
}

-(void)hideFormRow:(XLFormRowDescriptor*)formRow{
    NSUInteger index = [self.formRows indexOfObject:formRow];
    if (index != NSNotFound){
        [self removeObjectFromFormRowsAtIndex:index];
    }
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[XLFormRowDescriptor class]] &&
        ([keyPath isEqualToString:@"value"] || [keyPath isEqualToString:@"hidePredicateCache"] || [keyPath isEqualToString:@"disablePredicateCache"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if ([keyPath isEqualToString:@"value"]){
                [self.formDescriptor.delegate formRowDescriptorValueHasChanged:object oldValue:oldValue newValue:newValue];
            }
            else{
                [self.formDescriptor.delegate formRowDescriptorPredicateHasChanged:object oldValue:oldValue newValue:newValue predicateType:([keyPath isEqualToString:@"hidePredicateCache"] ? XLPredicateTypeHidden : XLPredicateTypeDisabled)];
            }
        }
    }
}



#pragma mark - KVC

-(NSUInteger)countOfFormRows
{
    return self.formRows.count;
}

- (id)objectInFormRowsAtIndex:(NSUInteger)index
{
    return [self.formRows objectAtIndex:index];
}

- (NSArray *)formRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.formRows objectsAtIndexes:indexes];
}

- (void)insertObject:(XLFormRowDescriptor *)formRow inFormRowsAtIndex:(NSUInteger)index
{
    formRow.sectionDescriptor = self;
    [formRow addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [formRow addObserver:self forKeyPath:@"disablePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [formRow addObserver:self forKeyPath:@"hidePredicateCache" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.formRows insertObject:formRow atIndex:index];
}

- (void)removeObjectFromFormRowsAtIndex:(NSUInteger)index
{
    XLFormRowDescriptor * formRow = [self.formRows objectAtIndex:index];
    @try {
        [formRow removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [formRow removeObserver:self forKeyPath:@"disablePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
    @try {
        [formRow removeObserver:self forKeyPath:@"hidePredicateCache"];
    }
    @catch (NSException * __unused exception) {}
    [self.formRows removeObjectAtIndex:index];
}

#pragma mark - KVC ALL

-(NSUInteger)countOfAllRows
{
    return self.allRows.count;
}

- (id)objectInAllRowsAtIndex:(NSUInteger)index
{
    return [self.allRows objectAtIndex:index];
}

- (NSArray *)allRowsAtIndexes:(NSIndexSet *)indexes
{
    return [self.allRows objectsAtIndexes:indexes];
}

- (void)insertObject:(XLFormRowDescriptor *)row inAllRowsAtIndex:(NSUInteger)index
{
    row.sectionDescriptor = self;
    [self.allRows insertObject:row atIndex:index];
    [self.formDescriptor addRowToTagCollection:row];
    row.disabled = row.disabled;
    row.hidden = row.hidden;
    
}

- (void)removeObjectFromAllRowsAtIndex:(NSUInteger)index
{
    XLFormRowDescriptor * row = [self.allRows objectAtIndex:index];
    [self.formDescriptor removeRowFromTagCollection:row];
    row.disabled = nil;
    row.hidden = nil;
    [self.allRows removeObjectAtIndex:index];
}

#pragma mark - Helpers

-(BOOL)canInsertUsingButton
{
    return (self.sectionInsertMode == XLFormSectionInsertModeButton && self.sectionOptions & XLFormSectionOptionCanInsert);
}

#pragma mark - Predicates



-(void)setHidePredicateCache:(NSNumber *)hidePredicateCache
{
    NSParameterAssert(hidePredicateCache);
    if (![_hidePredicateCache isEqualToNumber:hidePredicateCache]){
        _hidePredicateCache = hidePredicateCache;
        [_hidePredicateCache boolValue] ? [self.formDescriptor hideFormSection:self] : [self.formDescriptor showFormSection:self] ;
    }
}



-(BOOL)isHidden
{
    if (!self.hidePredicateCache) {
        return [self evaluateIsHidden];
    }
    return [self.hidePredicateCache boolValue];
}

-(BOOL)evaluateIsHidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]) {
        @try {
            self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.formDescriptor.allRowsByTag ?: @{}]);
        }
        @catch (NSException *exception) {
            // predicate syntax error.
            return NO;
        };
    }
    else{
        self.hidePredicateCache = [_hidden copy];
    }
    return [self.hidePredicateCache boolValue];
}


-(id)hidden
{
    return _hidden;
}

-(void)setHidden:(id)hidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([hidden isKindOfClass:[NSPredicate class]]){
        [self.formDescriptor addObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}


//-(void)addMissingRowDependencies
//{
//    if ([_hidden isKindOfClass:[NSPredicate class]]){
//        NSMutableArray* tags = [_hidden getPredicateVars];
//        for (int i = 0; i < tags.count; i++) {
//            [self.formDescriptor addObserver:self forRow:tags[i]];
//        }
//    }
//}

@end
