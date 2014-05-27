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

#import "XLFormViewController.h"
#import "XLFormRowDescriptor.h"

@interface XLFormRowDescriptor() <NSCopying>

@property UITableViewCell<XLFormDescriptorCell> * cell;

@end

@implementation XLFormRowDescriptor


-(id)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [self init];
    if (self){
        _tag = tag;
        _disabled = NO;
        _rowType = rowType;
        _title = title;
        _buttonViewControllerPresentationMode = XLFormPresentationModeDefault;
        _cellStype = UITableViewCellStyleValue1;
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
    if (_cell) return _cell;
    NSAssert(self.cellClass || [XLFormViewController cellClassesForRowDescriptorTypes][self.rowType], @"Not defined XLFormRowDescriptorType");
    _cell =  self.cellClass ? [[self.cellClass alloc] initWithStyle:self.cellStype reuseIdentifier:nil] : [[[XLFormViewController cellClassesForRowDescriptorTypes][self.rowType] alloc] initWithStyle:self.cellStype reuseIdentifier:nil];
    [self.cellConfigAtConfigure enumerateKeysAndObjectsUsingBlock:^(NSString *keyPath, id value, __unused BOOL *stop) {
        [_cell setValue:value forKeyPath:keyPath];
    }];
    return _cell;
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

// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    XLFormRowDescriptor * rowDescriptorCopy = [XLFormRowDescriptor formRowDescriptorWithTag:[self.tag copy] rowType:[self.rowType copy] title:[self.title copy]];
    rowDescriptorCopy.cellClass = [self.cellClass copy];
    rowDescriptorCopy.cellConfig = [self.cellConfig mutableCopy];
    rowDescriptorCopy.cellConfigAtConfigure = [self.cellConfigAtConfigure mutableCopy];
    rowDescriptorCopy.disabled = self.disabled;
    rowDescriptorCopy.required = self.required;
    
    // ================================
    // properties for Button
    // =================================
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

