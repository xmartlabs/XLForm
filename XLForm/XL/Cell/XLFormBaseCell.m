//
//  XLFormBaseCell.m
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

#import "XLFormBaseCell.h"
#import "UIView+XLFormAdditions.h"

@implementation XLFormBaseCell

@synthesize textLabel = _textLabel;

- (id)init
{
    return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}


-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self update];
}

#pragma mark - Properties

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    [_textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
	_textLabel.backgroundColor = [UIColor redColor];
    return _textLabel;
}

#pragma mark

- (void)configure
{
    //override
	[self setSelectionStyle:UITableViewCellSelectionStyleNone];

	[self.contentView addSubview:self.textLabel];
//	[self.contentView addConstraints:[self layoutConstraints]];
	[self updateConstraints];
	//NSDictionary * views = @{@"label": self.textLabel};
	//[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:0 metrics:0 views:views]];
	//[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];

//	[self.textLabel removeFromSuperview];
//	self.textLabel.hidden = YES;
	
	[self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
	
//	NSDictionary * views = @{@"label": self.textLabel};
//	[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:0 metrics:0 views:views];
//	[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views];


}

- (void)update
{
    // override
}

#pragma mark - Formatting

-(void)formatTextLabel
{
	if ([self.formViewController respondsToSelector:@selector(formatTextLabel:ofCell:)])
		[self.formViewController performSelector:@selector(formatTextLabel:ofCell:) withObject:self.rowDescriptor withObject:self];
	else
		self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title] : self.rowDescriptor.title);
}

#pragma mark - LayoutConstraints
//
//-(NSArray *)layoutConstraints
//{
//    NSMutableArray * result = [[NSMutableArray alloc] init];
//    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
//    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textLabelTitle]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:NSDictionaryOfVariableBindings(_textLabelTitle)]];
//	
//    return result;
//}

//-(NSArray *)layoutConstraints
//{
//    NSMutableArray * result = [[NSMutableArray alloc] init];
//	NSDictionary * views = @{@"textLabel": self.textLabel};
//    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textLabel]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
//    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_textLabel]-12-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
//    return result;
//}

//-(void)updateConstraints
//{
//	[super updateConstraints];
//	
//    if (self.dynamicCustomConstraints){
//        [self.contentView removeConstraints:self.dynamicCustomConstraints];
//    }
// 
//	NSArray* customContraints = nil;
//	if ([self.formViewController respondsToSelector:@selector(customConstraintsForCell:)])// && (customContraints = [self.formViewController performSelector:@selector(customConstraintsForCell:) withObject:self]))
//		//self.dynamicCustomConstraints = [NSMutableArray arrayWithArray:customContraints];
//		self.dynamicCustomConstraints = [self.formViewController performSelector:@selector(customConstraintsForCell:) withObject:self];
//	else
//	{
//		self.dynamicCustomConstraints = [NSMutableArray array];
//		NSDictionary * views = @{@"label": self.textLabel};
//		[self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:0 metrics:0 views:views]];
//		[self.dynamicCustomConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
//	}
//		
//	if (self.dynamicCustomConstraints)
//		[self.contentView addConstraints:self.dynamicCustomConstraints];
//}

-(void)updateConstraints
{
	[super updateConstraints];
	
    if (self.dynamicCustomConstraints){
        [self.contentView removeConstraints:self.dynamicCustomConstraints];
    }
	
	NSArray* customContraints = nil;
	if ([self.formViewController respondsToSelector:@selector(customConstraintsForCell:)] && (customContraints = [self.formViewController performSelector:@selector(customConstraintsForCell:) withObject:self]))
		self.dynamicCustomConstraints = [self.formViewController performSelector:@selector(customConstraintsForCell:) withObject:self];
	else
		self.dynamicCustomConstraints = [self defaultConstraints];
	
    [self.contentView addConstraints:self.dynamicCustomConstraints];
}

-(NSMutableArray*)defaultConstraints
{
	NSMutableArray* constraints = [NSMutableArray array];
	NSDictionary * views = @{@"label": self.textLabel};
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:0 metrics:0 views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
	return constraints;
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"]) ||  (object == self.imageView && [keyPath isEqualToString:@"image"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

@end
