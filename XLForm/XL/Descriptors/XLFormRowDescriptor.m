//
//  XLFormRowDescriptor.m
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

#import "XLForm.h"
#import "XLFormViewController.h"
#import "XLFormRowDescriptor.h"

@interface XLFormRowDescriptor() <NSCopying>

@property UITableViewCell<XLFormDescriptorCell> * cell;
@property (nonatomic) NSMutableArray *validators;

@end

@implementation XLFormRowDescriptor

@synthesize action = _action;

-(id)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [self init];
    if (self){
        NSAssert(((![rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] && ![rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]) || (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) && ([rowType isEqualToString:XLFormRowDescriptorTypeSelectorPopover] || [rowType isEqualToString:XLFormRowDescriptorTypeMultipleSelectorPopover]))), @"You must be running under UIUserInterfaceIdiomPad to use either XLFormRowDescriptorTypeSelectorPopover or XLFormRowDescriptorTypeMultipleSelectorPopover rows.");
        _tag = tag;
        _disabled = NO;
        _rowType = rowType;
        _title = title;
        _buttonViewControllerPresentationMode = XLFormPresentationModeDefault;
        _cellStype = UITableViewCellStyleValue1;
        _validators = [NSMutableArray new];
        
    }
    return self;
}

+(XLFormRowDescriptor *)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType
{
    return [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:rowType title:nil];
    
}

+(XLFormRowDescriptor *)formRowDescriptorWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title
{
    return [[XLFormRowDescriptor alloc] initWithTag:tag rowType:rowType title:title];
}

-(UITableViewCell<XLFormDescriptorCell> *)cellForFormController:(XLFormViewController *)formController
{
    id cellClass = self.cellClass ?: [XLFormViewController cellClassesForRowDescriptorTypes][self.rowType];
    NSAssert(cellClass, @"Not defined XLFormRowDescriptorType");
    if ([cellClass isKindOfClass:[NSString class]]) {
        UITableViewCell<XLFormDescriptorCell> * reuseCell = [formController.tableView dequeueReusableCellWithIdentifier:cellClass];
        if (reuseCell){
            _cell  = reuseCell;
            [self configureCellAtCreationTime];
        }
        else if (!_cell && [[NSBundle mainBundle] pathForResource:cellClass ofType:@"nib"]){
            _cell = [[[NSBundle mainBundle] loadNibNamed:cellClass owner:nil options:nil] firstObject];
            [self configureCellAtCreationTime];
        }
    } else if (!_cell) {
        _cell = [[cellClass alloc] initWithStyle:self.cellStype reuseIdentifier:nil];
        [self configureCellAtCreationTime];
    }
    NSAssert([_cell isKindOfClass:[UITableViewCell class]] && [_cell conformsToProtocol:@protocol(XLFormDescriptorCell)], @"Can not get a UITableViewCell form cellClass");
    return _cell;
}

- (void) configureCellAtCreationTime
{
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [_cell setValue:value forKeyPath:keyPath];
    }];
}

-(NSMutableDictionary *)cellConfig
{
    if (_cellConfig) return _cellConfig;
    _cellConfig = [NSMutableDictionary dictionary];
    return _cellConfig;
}

-(NSMutableDictionary *)cellConfigAtConfigure
{
    if (_cellConfigAtConfigure) return _cellConfigAtConfigure;
    _cellConfigAtConfigure = [NSMutableDictionary dictionary];
    return _cellConfigAtConfigure;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ (%@)", [super description], self.tag, self.rowType];
}

-(XLFormAction *)action
{
    if (!_action){
        _action = [[XLFormAction alloc] init];
    }
    return _action;
}

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormRowDescriptor * rowDescriptorCopy = [XLFormRowDescriptor formRowDescriptorWithTag:[self.tag copy] rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    rowDescriptorCopy.cellConfig = [self.cellConfig mutableCopy];
    rowDescriptorCopy.cellConfigAtConfigure = [self.cellConfigAtConfigure mutableCopy];
    rowDescriptorCopy.disabled = self.disabled;
    rowDescriptorCopy.required = self.required;
    
    // =====================
    // properties for Button
    // =====================
    rowDescriptorCopy.buttonViewController = [self.buttonViewController copy];
    rowDescriptorCopy.buttonViewControllerPresentationMode = self.buttonViewControllerPresentationMode;
    
    // ===========================
    // property used for Selectors
    // ===========================
    
    rowDescriptorCopy.noValueDisplayText = [self.noValueDisplayText copy];
    rowDescriptorCopy.selectorTitle = [self.selectorTitle copy];
    rowDescriptorCopy.selectorOptions = [self.selectorOptions copy];
    rowDescriptorCopy.leftRightSelectorLeftOptionSelected = [self.leftRightSelectorLeftOptionSelected copy];
    // =====================================
    // properties used for dynamic selectors
    // =====================================
    rowDescriptorCopy.selectorControllerClass = [self.selectorControllerClass copy];
    
    return rowDescriptorCopy;
}


#pragma mark - validation

-(void) addValidator: (id<XLFormValidatorProtocol>) validator {
    if (validator == nil || ![validator conformsToProtocol:@protocol(XLFormValidatorProtocol)])
        return;
    
    if(![self.validators containsObject:validator]) {
        [self.validators addObject:validator];
    }
}

-(void) removeValidator: (id<XLFormValidatorProtocol>) validator {
    if (validator == nil|| ![validator conformsToProtocol:@protocol(XLFormValidatorProtocol)])
        return;
    
    if ([self.validators containsObject:validator]) {
        [self.validators removeObject:validator];
    }
}

-(XLFormValidationStatus *) doValidation {
    XLFormValidationStatus *valStatus = [XLFormValidationStatus formValidationStatusWithMsg:@"" status:YES];
    
    if (self.required) {
        // do required validation here
        if (self.value == nil) { // || value.length() == 0
            valStatus.isValid = NO;
            NSString *msg = nil;
            if (self.requireMsg != nil) {
                msg = self.requireMsg;
            } else {
                // default message for required msg
                msg = NSLocalizedString(@"%@ can't be empty", nil);
            }
            valStatus.msg = [NSString stringWithFormat:msg, self.title];
            
            return valStatus;
        }
    } else {
        // if user has not enter anything, we dun display the valid icon
        if (self.value == nil) {// || value.length() == 0
            valStatus = nil; // optional field, we will mark this validation as optional by passing null
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

-(void)setFormSelector:(SEL)formSelector
{
    _formBlock = nil;
    _formSelector = formSelector;
}


-(void)setFormBlock:(void (^)(XLFormRowDescriptor *))formBlock
{
    _formSelector = nil;
    _formBlock = formBlock;
}

@end

