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

@interface XLFormRowDescriptor() <NSCopying>

@property XLFormBaseCell * cell;
@property (nonatomic) NSMutableArray *validators;

@property (nonatomic, readwrite) NSPredicate* disablePredicate;
@property (nonatomic) NSMutableDictionary* predicateVariables;

@end

@implementation XLFormRowDescriptor

@synthesize action = _action;
@synthesize disabled = _disabled;

-(id)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [self init];
    if (self){
        NSAssert(((![rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] && ![rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) || (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] || [rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]))), @"You must be running under UIUserInterfaceIdiomPad to use either XLFormRowDescriptorTypeSelectorPopover or XLFormRowDescriptorTypeMultipleSelectorPopover rows.");
        _tag = tag;
        _disabled = NO;
        _predicateVariables = [[NSMutableDictionary alloc] init];
        _rowType = rowType;
        _title = title;
        _cellStyle = UITableViewCellStyleValue1;
        _validators = [NSMutableArray new];
        _cellConfig = [NSMutableDictionary dictionary];
        _cellConfigIfDisabled = [NSMutableDictionary dictionary];
        _cellConfigAtConfigure = [NSMutableDictionary dictionary];
        _observers = [NSMutableArray array];
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
    id cellClass = self.cellClass ?: [XLFormViewController cellClassesForRowDescriptorTypes][self.rowType];
    NSAssert(cellClass, @"Not defined XLFormRowDescriptorType");
    if (!_cell){
        if ([cellClass isKindOfClass:[NSString class]]) {
            if ([[NSBundle mainBundle] pathForResource:cellClass ofType:@"nib"]){
                _cell = [[[NSBundle mainBundle] loadNibNamed:cellClass owner:nil options:nil] firstObject];
                [self configureCellAtCreationTime];
            }
        } else if (!_cell) {
            _cell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
            [self configureCellAtCreationTime];
        }
        NSAssert([_cell isKindOfClass:[XLFormBaseCell class]], @"Can not get a XLFormBaseCell");
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

-(BOOL)isDisabled
{
    return _disabled || self.sectionDescriptor.formDescriptor.isDisabled;
}

-(void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
}

-(BOOL)isDisabledPredicate
{
    if(!_disablePredicate || self.isDisabled)
        return self.isDisabled;
    @try {
        return [_disablePredicate evaluateWithObject:self substitutionVariables:_predicateVariables];
    }
    @catch (NSException *exception) {
        // predicate syntax error. 
        return self.isDisabled;
    };
}

-(void)setPredicate:(id) disablePredicate{
    XLFormRowDescriptor* obs;
    NSString* separator = @"$";
    if ([disablePredicate isKindOfClass:[NSString class]]){
        //preprocess string
        
        NSArray* tokens = [disablePredicate componentsSeparatedByString:separator];
        NSMutableString* new_string = [[NSMutableString alloc] initWithString:tokens[0]];
        NSRange range;
        for (int i = 1; i < tokens.count; i++) {
            [new_string appendString:separator];
            NSMutableString* tag = [[tokens[i] componentsSeparatedByString:@" "][0] componentsSeparatedByString:@"."][0];
            obs = [self.sectionDescriptor.formDescriptor formRowWithTag:tag];
            if (obs){
                [obs addObserverRow:self];
                _predicateVariables[tag] = obs;
            }
            else{
                return; // wrong tag
            }
            [new_string appendString:tag];
            range = [tokens[i] rangeOfString:[NSString stringWithFormat:@"%@", tag]];
            if (![[tokens[i] substringWithRange:NSMakeRange(range.location + range.length, 6)] isEqualToString:@".value"]){
                [new_string appendString:@".value"];
                
            }
            [new_string appendString:[tokens[i] substringFromIndex:range.location + range.length]];
        }
        _disablePredicate = [NSPredicate predicateWithFormat:new_string];
    }
    else if ([disablePredicate isKindOfClass:[NSPredicate class]]){
        // get vars from predicate
        
        NSMutableArray* tokens = [self getPredicateVars:disablePredicate];
        for (int i = 0; i < tokens.count; i++) {
            obs = [self.sectionDescriptor.formDescriptor formRowWithTag:tokens[i]];
            if (obs){
                [obs addObserverRow:self];
                _predicateVariables[tokens[i]] = obs;
            }
            else{
                return; // wrong tag
            }
        }
        _disablePredicate = disablePredicate;
    }
}

-(NSMutableArray*) getPredicateVars:(NSPredicate*) predicate {
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    if ([predicate isKindOfClass:([NSCompoundPredicate class])]) {
        for (id object in ((NSCompoundPredicate*) predicate).subpredicates ) {
            [ret addObjectsFromArray:[self getPredicateVars:object]];
        }
    }
    else if ([predicate isKindOfClass:([NSComparisonPredicate class])]){
        [ret addObjectsFromArray:[self getExpressionVars:((NSComparisonPredicate*) predicate).leftExpression]];
        [ret addObjectsFromArray:[self getExpressionVars:((NSComparisonPredicate*) predicate).rightExpression]];
    }
    return ret;
}

-(NSMutableArray*) getExpressionVars:(NSExpression*) expression{
    switch (expression.expressionType) {
        case NSFunctionExpressionType:{
            NSString* str = [NSString stringWithFormat:@"%@", expression];
            if ([str containsString:@"."])
                str = [str substringWithRange:NSMakeRange(1, [str rangeOfString:@"."].location - 1)];
            else
                str = [str substringFromIndex:1];
            return [[NSMutableArray alloc] initWithObjects: str, nil];
            break;
        }
        default:
            return nil;
            break;
    }
}

/*
-(void)setPredicateVariables:(NSDictionary *)predicateVariables{
    _predicateVariables = predicateVariables;
    XLFormRowDescriptor* row = [predicateVariables objectForKey:@"preddep"];
    [row addObserverRow:self];
}
*/
-(void)addObserverRow:(XLFormRowDescriptor*) rowDescriptor{
    if (![_observers containsObject:rowDescriptor])
        [_observers addObject:rowDescriptor];
}

-(void)delObserverRow:(XLFormRowDescriptor*) rowDescriptor{
    [_observers removeObject:rowDescriptor];
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormRowDescriptor * rowDescriptorCopy = [XLFormRowDescriptor formRowDescriptorWithTag:[self.tag copy] rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    rowDescriptorCopy.cellConfig = [self.cellConfig mutableCopy];
    rowDescriptorCopy.cellConfigAtConfigure = [self.cellConfigAtConfigure mutableCopy];
    rowDescriptorCopy.disabled = self.isDisabled;
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

