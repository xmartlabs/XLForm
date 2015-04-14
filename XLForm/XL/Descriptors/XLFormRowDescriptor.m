//
//  XLFormRowDescriptor.m
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
#import "XLFormViewController.h"
#import "XLFormRowDescriptor.h"
#import "NSString+XLFormAdditions.h"

@interface XLFormDescriptor (_XLFormRowDescriptor)

@property (readonly) NSMutableDictionary* allRowsByTag;

-(void)addObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;
-(void)removeObserversOfObject:(id)sectionOrRow predicateType:(XLPredicateType)predicateType;

@end

@interface XLFormRowDescriptor() <NSCopying>

@property XLFormBaseCell * cell;
@property (nonatomic) NSMutableArray *validators;

@property NSNumber * disablePredicateCache;
@property (nonatomic) NSNumber * hidePredicateCache;

@end

@implementation XLFormRowDescriptor

@synthesize action = _action;
@synthesize disabled = _disabled;
@synthesize hidden = _hidden;

-(id)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [self init];
    if (self){
        NSAssert(((![rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] && ![rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) || (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] || [rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]))), @"You must be running under UIUserInterfaceIdiomPad to use either XLFormRowDescriptorTypeSelectorPopover or XLFormRowDescriptorTypeMultipleSelectorPopover rows.");
        _tag = tag;
        _disabled = @NO;
        _hidden = @NO;
        _rowType = rowType;
        _title = title;
        _cellStyle = UITableViewCellStyleValue1;
        _validators = [NSMutableArray new];
        _cellConfig = [NSMutableDictionary dictionary];
        _cellConfigIfDisabled = [NSMutableDictionary dictionary];
        _cellConfigAtConfigure = [NSMutableDictionary dictionary];
    }
    return self;
}

+(id)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType
{
    return [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:rowType title:nil];
}

+(id)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[XLFormRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

-(XLFormBaseCell *)cellForFormController:(XLFormViewController *)formController
{
    if (!_cell){
        id cellClass = self.cellClass ?: [XLFormViewController cellClassesForRowDescriptorTypes][self.rowType];
        NSAssert(cellClass, @"Not defined XLFormRowDescriptorType: %@", self.rowType ?: @"");
        if ([cellClass isKindOfClass:[NSString class]]) {
            if ([[NSBundle mainBundle] pathForResource:cellClass ofType:@"nib"]){
                _cell = [[[NSBundle mainBundle] loadNibNamed:cellClass owner:nil options:nil] firstObject];
            }
        } else {
            _cell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        }
        NSAssert([_cell isKindOfClass:[XLFormBaseCell class]], @"UITableViewCell must extend from XLFormBaseCell");
        [self configureCellAtCreationTime];
    }
    return _cell;
}

- (void)configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [_cell setValue:(value == [NSNull null]) ? nil : value forKeyPath:keyPath];
    }];
}

-(NSMutableDictionary *)cellConfig
{
    if (_cellConfig) return _cellConfig;
    _cellConfig = [NSMutableDictionary dictionary];
    return _cellConfig;
}

-(NSMutableDictionary *)cellConfigIfDisabled
{
    if (_cellConfigIfDisabled) return _cellConfigIfDisabled;
    _cellConfigIfDisabled = [NSMutableDictionary dictionary];
    return _cellConfigIfDisabled;
}

-(NSMutableDictionary *)cellConfigAtConfigure
{
    if (_cellConfigAtConfigure) return _cellConfigAtConfigure;
    _cellConfigAtConfigure = [NSMutableDictionary dictionary];
    return _cellConfigAtConfigure;
}

-(NSString *)description
{
    return self.tag;  // [NSString stringWithFormat:@"%@ - %@ (%@)", [super description], self.tag, self.rowType];
}

-(XLFormAction *)action
{
    if (!_action){
        _action = [[XLFormAction alloc] init];
    }
    return _action;
}

-(void)setAction:(XLFormAction *)action
{
    _action = action;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormRowDescriptor * rowDescriptorCopy = [XLFormRowDescriptor formRowDescriptorWithTag:[self.tag copy] rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    rowDescriptorCopy.cellConfig = [self.cellConfig mutableCopy];
    rowDescriptorCopy.cellConfigAtConfigure = [self.cellConfigAtConfigure mutableCopy];
    rowDescriptorCopy.hidden = _hidden;
    rowDescriptorCopy.disabled = _disabled;
    rowDescriptorCopy.required = self.isRequired;
    
    // =====================
    // properties for Button
    // =====================
    rowDescriptorCopy.action = [self.action copy];
    
    
    // ===========================
    // property used for Selectors
    // ===========================
    
    rowDescriptorCopy.noValueDisplayText = [self.noValueDisplayText copy];
    rowDescriptorCopy.selectorTitle = [self.selectorTitle copy];
    rowDescriptorCopy.selectorOptions = [self.selectorOptions copy];
    rowDescriptorCopy.leftRightSelectorLeftOptionSelected = [self.leftRightSelectorLeftOptionSelected copy];
    
    return rowDescriptorCopy;
}

#pragma mark - Disable Predicate functions

-(BOOL)isDisabled
{
    if ( self.sectionDescriptor.formDescriptor.isDisabled ){
        return YES;
    }
    if (!self.disablePredicateCache) {
        if ([_disabled isKindOfClass:[NSPredicate class]]) {
            [self evaluateIsDisabled];
        }
        else{
            self.disablePredicateCache = [_disabled copy];
        }
    }
    return [self.disablePredicateCache boolValue];
}

-(void)setDisabled:(id)disabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeDisabled];
    }
    _disabled = [disabled isKindOfClass:[NSString class]] ? [disabled formPredicate] : disabled;
    if ([_disabled isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:XLPredicateTypeDisabled];
    }
    [self evaluateIsDisabled];
}

#pragma mark - Hide Predicate functions

-(void)setHidePredicateCache:(NSNumber *)hidePredicateCache
{
    NSParameterAssert(hidePredicateCache);
    if (![_hidePredicateCache isEqualToNumber:hidePredicateCache]){
        _hidePredicateCache = hidePredicateCache;
        [_hidePredicateCache boolValue] ? [self.sectionDescriptor hideFormRow:self] : [self.sectionDescriptor showFormRow:self] ;
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
            self.hidePredicateCache = @([_hidden evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
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

-(id)evaluateIsDisabled
{
    if ([_disabled isKindOfClass:[NSPredicate class]]) {
        @try {
            self.disablePredicateCache = @([_disabled evaluateWithObject:self substitutionVariables:self.sectionDescriptor.formDescriptor.allRowsByTag ?: @{}]);
        }
        @catch (NSException *exception) {
            // predicate syntax error.
            return @NO;
        };
    }
    else{
        self.disablePredicateCache = [_disabled copy];
    }
    return self.disablePredicateCache;
}

-(void)setHidden:(id)hidden
{
    if ([_hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor removeObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    _hidden = [hidden isKindOfClass:[NSString class]] ? [hidden formPredicate] : hidden;
    if ([hidden isKindOfClass:[NSPredicate class]]){
        [self.sectionDescriptor.formDescriptor addObserversOfObject:self predicateType:XLPredicateTypeHidden];
    }
    [self evaluateIsHidden]; // check and update if this row should be hidden.
}

-(id)hidden
{
    return _hidden;
}

-(void)hiddenValueDidChange{
    if ([self isHidden]) {
        [self.sectionDescriptor hideFormRow:self];
    }
    else{
        [self.sectionDescriptor showFormRow:self];
    }
}

//-(void)addMissingRowDependencies{
//    NSMutableArray* tags;
//    if ([_disabled isKindOfClass:[NSPredicate class]]){
//        tags = [_disabled getPredicateVars];
//        for (int i = 0; i < tags.count; i++) {
//            [self.sectionDescriptor.formDescriptor addObserver:self.tag forRow:tags[i]];
//        }
//    }
//    if ([_hidden isKindOfClass:[NSPredicate class]]){
//        tags = [_hidden getPredicateVars];
//        for (int i = 0; i < tags.count; i++) {
//            [self.sectionDescriptor.formDescriptor addObserver:self.tag forRow:tags[i]];
//        }
//    }
//}

//-(void)clearRowDependencies{
//    NSMutableArray* tags;
//    if ([_disabled isKindOfClass:[NSPredicate class]]){
//        tags = [_disabled getPredicateVars];
//        for (int i = 0; i < tags.count; i++) {
//            [self.sectionDescriptor.formDescriptor removeObserver:self.tag forRow:tags[i]];
//        }
//    }
//    if ([_hidden isKindOfClass:[NSPredicate class]]){
//        tags = [_hidden getPredicateVars];
//        for (int i = 0; i < tags.count; i++) {
//            [self.sectionDescriptor.formDescriptor removeObserver:self.tag forRow:tags[i]];
//        }
//    }
//}


#pragma mark - validation

-(void)addValidator:(id<XLFormValidatorProtocol>)validator
{
    if (validator == nil || ![validator conformsToProtocol:@protocol(XLFormValidatorProtocol)])
        return;
    
    if(![self.validators containsObject:validator]) {
        [self.validators addObject:validator];
    }
}

-(void)removeValidator:(id<XLFormValidatorProtocol>)validator
{
    if (validator == nil|| ![validator conformsToProtocol:@protocol(XLFormValidatorProtocol)])
        return;
    
    if ([self.validators containsObject:validator]) {
        [self.validators removeObject:validator];
    }
}

- (BOOL)valueIsEmpty
{
    return self.value == nil || [self.value isKindOfClass:[NSNull class]] || ([self.value respondsToSelector:@selector(length)] && [self.value length]==0);
}

-(XLFormValidationStatus *)doValidation
{
    XLFormValidationStatus *valStatus = nil;
    
    if (self.required) {
        // do required validation here
        if ([self valueIsEmpty]) {
            valStatus = [XLFormValidationStatus formValidationStatusWithMsg:@"" status:NO rowDescriptor:self];
            NSString *msg = nil;
            if (self.requireMsg != nil) {
                msg = self.requireMsg;
            } else {
                // default message for required msg
                msg = NSLocalizedString(@"%@ can't be empty", nil);
            }
            
            if (self.title != nil) {
                valStatus.msg = [NSString stringWithFormat:msg, self.title];
            } else {
                valStatus.msg = [NSString stringWithFormat:msg, self.tag];
            }

            return valStatus;
        }
    }
    // custom validator
    for(id<XLFormValidatorProtocol> v in self.validators) {
        if ([v conformsToProtocol:@protocol(XLFormValidatorProtocol)]) {
            XLFormValidationStatus *vStatus = [v isValid:self];
            // fail validation
            if (vStatus != nil && !vStatus.isValid) {
                return vStatus;
            }
            valStatus = vStatus;
        } else {
            valStatus = nil;
        }
    }
    return valStatus;
}


#pragma mark - Deprecations

-(void)setButtonViewController:(Class)buttonViewController
{
    self.action.viewControllerClass = buttonViewController;
}

-(Class)buttonViewController
{
    return self.action.viewControllerClass;
}

-(void)setSelectorControllerClass:(Class)selectorControllerClass
{
    self.action.viewControllerClass = selectorControllerClass;
}

-(Class)selectorControllerClass
{
    return self.action.viewControllerClass;
}

-(void)setButtonViewControllerPresentationMode:(XLFormPresentationMode)buttonViewControllerPresentationMode
{
    self.action.viewControllerPresentationMode = buttonViewControllerPresentationMode;
}

-(XLFormPresentationMode)buttonViewControllerPresentationMode
{
    return self.action.viewControllerPresentationMode;
}

@end



@implementation XLFormLeftRightSelectorOption


+(XLFormLeftRightSelectorOption *)formLeftRightSelectorOptionWithLeftValue:(id)leftValue
                                                          httpParameterKey:(NSString *)httpParameterKey
                                                              rightOptions:(NSArray *)rightOptions;
{
    return [[XLFormLeftRightSelectorOption alloc] initWithLeftValue:leftValue
                                                   httpParameterKey:httpParameterKey
                                                       rightOptions:rightOptions];
}


-(id)initWithLeftValue:(NSString *)leftValue httpParameterKey:(NSString *)httpParameterKey rightOptions:(NSArray *)rightOptions
{
    self = [super init];
    if (self){
        _selectorTitle = nil;
        _leftValue = leftValue;
        _rightOptions = rightOptions;
        _httpParameterKey = httpParameterKey;
    }
    return self;
}


@end

@implementation XLFormAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewControllerPresentationMode = XLFormPresentationModeDefault;
    }
    return self;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormAction * actionCopy = [[XLFormAction alloc] init];
    actionCopy.viewControllerPresentationMode = self.viewControllerPresentationMode;
    if (self.viewControllerClass){
        actionCopy.viewControllerClass = [self.viewControllerClass copy];
    }
    else if ([self.viewControllerStoryboardId length]  != 0){
        actionCopy.viewControllerStoryboardId = [self.viewControllerStoryboardId copy];
    }
    else if ([self.viewControllerNibName length] != 0){
        actionCopy.viewControllerNibName = [self.viewControllerNibName copy];
    }
    if (self.formBlock){
        actionCopy.formBlock = [self.formBlock copy];
    }
    else if (self.formSelector){
        actionCopy.formSelector = self.formSelector;
    }
    else if (self.formSegueIdenfifier){
        actionCopy.formSegueIdenfifier = [self.formSegueIdenfifier copy];
    }
    else if (self.formSegueClass){
        actionCopy.formSegueClass = [self.formSegueClass copy];
    }
    return actionCopy;
}

-(void)setViewControllerClass:(Class)viewControllerClass
{
    _viewControllerClass = viewControllerClass;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerNibName:(NSString *)viewControllerNibName
{
    _viewControllerClass = nil;
    _viewControllerNibName = viewControllerNibName;
    _viewControllerStoryboardId = nil;
}

-(void)setViewControllerStoryboardId:(NSString *)viewControllerStoryboardId
{
    _viewControllerClass = nil;
    _viewControllerNibName = nil;
    _viewControllerStoryboardId = viewControllerStoryboardId;
}


-(void)setFormSelector:(SEL)formSelector
{
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdenfifier = nil;
    _formSelector = formSelector;
}


-(void)setFormBlock:(void (^)(XLFormRowDescriptor *))formBlock
{
    _formSegueClass = nil;
    _formSegueIdenfifier = nil;
    _formSelector = nil;
    _formBlock = formBlock;
}

-(void)setFormSegueClass:(Class)formSegueClass
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueIdenfifier = nil;
    _formSegueClass = formSegueClass;
}

-(void)setFormSegueIdenfifier:(NSString *)formSegueIdenfifier
{
    _formSelector = nil;
    _formBlock = nil;
    _formSegueClass = nil;
    _formSegueIdenfifier = formSegueIdenfifier;
}

@end

