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

@property (nonatomic) UISlider * slider;
@property (nonatomic) UILabel * textLabel;
@property NSUInteger steps;

@end

@implementation XLFormSliderCell

@synthesize textLabel = _textLabel;

- (void)configure
{
	self.steps = 0;
	[self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.contentView addSubview:self.slider];
	[self.contentView addSubview:self.textLabel];
    	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
	[self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:44]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:0 views:@{@"textLabel": self.textLabel}]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[slider]-|" options:0 metrics:0 views:@{@"slider": self.slider}]];
	
	[self valueChanged:nil];
}

-(void)update {
	
    [super update];
    self.textLabel.text = self.rowDescriptor.title;
    self.slider.value = [self.rowDescriptor.value floatValue];
    self.slider.enabled = !self.rowDescriptor.isDisabled;
    [self valueChanged:nil];
}

-(void)valueChanged:(UISlider*)_slider {
	if(self.steps != 0) {
		self.slider.value = roundf((self.slider.value-self.slider.minimumValue)/(self.slider.maximumValue-self.slider.minimumValue)*self.steps)*(self.slider.maximumValue-self.slider.minimumValue)/self.steps + self.slider.minimumValue;
	}
	self.rowDescriptor.value = @(self.slider.value);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
	return 88;
}


-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    return _textLabel;
}

-(UISlider *)slider
{
    if (_slider) return _slider;
    _slider = [UISlider autolayoutView];
    return _slider;
}

@end
