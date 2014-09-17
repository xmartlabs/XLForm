//
//  UICustomizationFormViewController.m
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
#import "UICustomizationFormViewController.h"

@implementation UICustomizationFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"UI Customization"];
        XLFormSectionDescriptor * section;
        XLFormRowDescriptor * row;
        
        
        // Section
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        // Name
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Name" rowType:XLFormRowDescriptorTypeText title:@"Name"];
        // change the background color
        [row.cellConfigAtConfigure setObject:[UIColor greenColor] forKey:@"backgroundColor"];
        // font
        [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:30] forKey:@"textLabel.font"];
        // background color
        [row.cellConfig setObject:[UIColor grayColor] forKey:@"textField.backgroundColor"];
        // font
        [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:25] forKey:@"textField.font"];
        // alignment
        [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
        [section addFormRow:row];
        
        
        // Section
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
		
		// Formatting
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Required" rowType:XLFormRowDescriptorTypeText title:@"Required"];
		row.required = YES;
		[section addFormRow:row];
		
		
		// Section
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
		
		// AutoLayout
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LayoutText" rowType:XLFormRowDescriptorTypeText title:@"LayoutText"];
		row.required = YES;
		[section addFormRow:row];
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LayoutSwitch" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"LayoutSwitch"];
		row.required = YES;
		[section addFormRow:row];
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LayoutDatePicker" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"LayoutDatePicker"];
		row.required = YES;
		[section addFormRow:row];
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LayoutSegmentedControl" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"LayoutSegmentedControl"];
		row.required = YES;
		row.selectorOptions = @[@"YES", @"NO", @"MAYBE"];
		[section addFormRow:row];
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LayoutSelectorPush" rowType:XLFormRowDescriptorTypeSelectorPush title:@"LayoutSelectorPush"];
		row.required = YES;
		row.selectorOptions = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5"];
		[section addFormRow:row];
		
		
		// Section
        section = [XLFormSectionDescriptor formSection];
        [form addFormSection:section];
        
        //Button
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Button" rowType:XLFormRowDescriptorTypeButton title:@"Button"];
        [row.cellConfigAtConfigure setObject:[UIColor purpleColor] forKey:@"backgroundColor"];
        [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.color"];
        [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:40] forKey:@"textLabel.font"];
        [section addFormRow:row];
        
        self.form = form;
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cell height of a particular cell
    if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:@"Name"]){
        return 60.0;
    }
    else if ([[self.form formRowAtIndex:indexPath].tag isEqualToString:@"Button"]){
        return 100.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Formatting

-(void)formatTextLabel:(XLFormRowDescriptor *)formRow ofCell:(XLFormBaseCell *)cell
{
	cell.textLabel.text = formRow.title;

	cell.textLabel.textAlignment = NSTextAlignmentRight;
}

#pragma mark - AutoLayout

-(NSArray *)customConstraintsForCell:(XLFormBaseCell *)cell
{
	static NSInteger textFieldWidth = 200;
	
	if ([cell isMemberOfClass:[XLFormButtonCell class]])
		return nil;
	
	NSMutableArray* constraints = [NSMutableArray array];
	
	if ([cell isKindOfClass:[XLFormTextFieldCell class]])
	{
		XLFormTextFieldCell* textFieldCell = (XLFormTextFieldCell*)cell;
		NSDictionary * views = @{@"label": textFieldCell.textLabel, @"textField": textFieldCell.textField};
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-[label(%d@1000)]-[textField]-|", textFieldWidth] options:0 metrics:0 views:views]];
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[textField]-12-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
	}
	else
	{
		NSDictionary * views = @{@"label": cell.textLabel};
		
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-[label(%d@1000)]", textFieldWidth] options:0 metrics:0 views:views]];
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]-12-|" options:NSLayoutFormatAlignAllBaseline metrics:0 views:views]];
	}
	
	return constraints;
}



@end
