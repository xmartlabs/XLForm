//
//  XLFormPickerCell.m
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

#import "UIView+XLFormAdditions.h"
#import "XLFormPickerCell.h"

@interface XLFormPickerCell() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (readonly) NSArray *options;
@property (readonly) BOOL optionsAreMultidimensional;
@property id value;

@end

@implementation XLFormPickerCell

@synthesize pickerView = _pickerView;
@synthesize inlineRowDescriptor = _inlineRowDescriptor;

-(BOOL)canResignFirstResponder
{
    return YES;
}

-(BOOL)canBecomeFirstResponder
{
    return (self.inlineRowDescriptor == nil);
}

#pragma mark - Properties

-(UIPickerView *)pickerView
{
    if (_pickerView) return _pickerView;
    _pickerView = [UIPickerView autolayoutView];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}

- (NSArray *)options
{
    if (self.inlineRowDescriptor) {
        return self.inlineRowDescriptor.selectorOptions;
    }
    
    return self.rowDescriptor.selectorOptions;
}

- (BOOL)optionsAreMultidimensional
{
    return [self.options.firstObject isKindOfClass:[NSArray class]];
}

- (id)value
{
    return self.inlineRowDescriptor ? self.inlineRowDescriptor.value : self.rowDescriptor.value;
}

- (void)setValue:(id)value
{
    if (self.inlineRowDescriptor) {
        self.inlineRowDescriptor.value = value;
    }
    else {
        self.rowDescriptor.value = value;
    }
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

-(void)update
{
    [super update];
    
    if (self.optionsAreMultidimensional) {
        for (int i=0; i<self.options.count; i++) {
            id value = [self.value objectAtIndex:i];
            NSUInteger index = [self indexOfOptionWithValue:value fromOptions:[self.options objectAtIndex:i]];
            
            if (index != NSNotFound) {
                [self.pickerView selectRow:index inComponent:i animated:NO];
            }
        }
    }
    else {
        NSUInteger index = [self indexOfOptionWithValue:self.value fromOptions:self.options];
        
        if (index != NSNotFound) {
            [self.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
    
    [self.pickerView reloadAllComponents];
    
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 216.0f;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.optionsAreMultidimensional) {
        return [[[self.options objectAtIndex:component] objectAtIndex:row] displayText];
    }
    
    return [[self.options objectAtIndex:row] displayText];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.value = [self valueFromComponents];
    
    if (self.inlineRowDescriptor){
        [[self.inlineRowDescriptor cellForFormController:self.formViewController] update];
    }
    else{
        [self becomeFirstResponder];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.optionsAreMultidimensional) {
        return self.options.count;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.optionsAreMultidimensional) {
        return [[self.options objectAtIndex:component] count];
    }
    
    return self.options.count;
}

#pragma mark - helpers

- (id)valueFromComponents
{
    if (self.optionsAreMultidimensional) {
        NSMutableArray *values = [NSMutableArray array];
        
        for (int component=0; component<self.pickerView.numberOfComponents; component++) {
            NSInteger row = [self.pickerView selectedRowInComponent:component];
            [values addObject: [[self.options objectAtIndex:component] objectAtIndex:row]];
        }
        
        return values;
    }
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    
    return [self.options objectAtIndex:row];
}

-(NSUInteger)indexOfOptionWithValue:(id)value fromOptions:(NSArray *)options
{
    return [options indexOfObjectPassingTest:^BOOL(id option, NSUInteger idx, BOOL *stop) {
        return [[option valueData] isEqual:[value valueData]];
    }];
}

@end
