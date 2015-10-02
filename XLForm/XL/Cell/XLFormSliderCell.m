//
//  XLFormSliderCell.m
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

#import "XLFormSliderCell.h"
#import "UIView+XLFormAdditions.h"

@interface XLFormSliderCell ()

@property NSMutableArray * dynamicCustomConstraints;
@property UISlider* slider;
@property UILabel* textField;
@property NSUInteger steps;

@end

@implementation XLFormSliderCell

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == self.textField && [keyPath isEqualToString:@"text"]){
    if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
      [self.contentView setNeedsUpdateConstraints];
    }
  }
}

- (void)configure
{

	self.steps = 0;

	self.slider = [UISlider autolayoutView];
	[self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.contentView addSubview:self.slider];
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	self.textField = [UILabel autolayoutView];
	[self.contentView addSubview:self.textField];
  [self.contentView addConstraints:[self layoutConstraints]];

	[self valueChanged:nil];
}

-(void)update {

    [super update];
    self.textField.text = self.rowDescriptor.title;
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.disabled;
    self.textField.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];

    [self valueChanged:nil];
}

#pragma mark - LayoutConstraints

-(NSArray *)layoutConstraints
{
  NSMutableArray * result = [[NSMutableArray alloc] init];
  [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[textField]-15-|" options:0 metrics:0 views:@{@"textField": self.textField}]];
  [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[slider]-15-|" options:0 metrics:0 views:@{@"slider": self.slider}]];
  return result;
}

-(void)updateConstraints
{
  if (self.dynamicCustomConstraints){
    [self.contentView removeConstraints:self.dynamicCustomConstraints];
  }
  self.dynamicCustomConstraints = [NSMutableArray array];
  if (self.rowDescriptor.title == nil || [self.rowDescriptor.title isEqualToString:@""]) {
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
  } else {
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.dynamicCustomConstraints addObject:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44]];
  }

  [self.contentView addConstraints:self.dynamicCustomConstraints];
  [super updateConstraints];
}

-(void)valueChanged:(UISlider*)_slider {
	if(self.steps != 0) {
		self.slider.value = roundf((self.slider.value-self.slider.minimumValue)/(self.slider.maximumValue-self.slider.minimumValue)*self.steps)*(self.slider.maximumValue-self.slider.minimumValue)/self.steps + self.slider.minimumValue;
	}
	self.rowDescriptor.value = @(self.slider.value);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
  if (rowDescriptor.title == nil || [rowDescriptor.title isEqualToString:@""]) {
    return 40;
  } else {
    return 88;
  }
}

@end
