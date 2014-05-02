//
//  XLFormCustomCell.m
//  XLForm
//
//  Created by Shams on 01/05/2014.
//  Copyright (c) 2014 Xmartlabs. All rights reserved.
//

#import "XLFormCustomCell.h"

@implementation XLFormCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.text = @"am a custom cell select me!";
        
    }
    return self;
}

- (void)configure
{
    //override
}

- (void)update
{
    // override
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    // custom code here
    // i.e new behaviour when cell has been selected
    self.textLabel.text = @"can do any custom behaviour";
    self.rowDescriptor.value = @"can do any custom behaviour";
}

/*
+(CGFloat)formDescriptorCellHeightForRowDescription:(XLFormRowDescriptor *)rowDescriptor
{
    // return custom cell size
    return 40;
}
*/

/*
-(BOOL)formDescriptorCellBecomeFirstResponder
{
    // custom code
    return YES;
}
*/

/*
-(BOOL)formDescriptorCellResignFirstResponder
{
    // custom code
    return YES;
}
*/

/*
-(NSError *)formDescriptorCellLocalValidation
{
    // custom error handler
    // compare with a custom property if it should return a error
    // i.e some textfield is empty etc...
    if (self.rowDescriptor.required){
        return [[NSError alloc] initWithDomain:XLFormErrorDomain code:XLFormErrorCodeRequired userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"%@ can't be empty", nil), self.rowDescriptor.title] }];
        
    }
    return nil;
}
*/

/*
-(NSString *)formDescriptorHttpParameterName 
{
  // custom code
}
*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
