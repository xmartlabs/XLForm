//
//  XLFormTestCase.m
//  XLForm Tests
//
//  Created by Martin Barreto on 8/5/14.
//
//

#import "XLTestCase.h"

@implementation XLTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self buildForm];
    [self forceLoadingOfTheView]; // Load the view
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.formController = nil;
    [super tearDown];
}


#pragma mark - Helpers

-(void)buildForm
{
}


-(XLFormViewController *)formController
{
    if (_formController) return _formController;
    _formController = [[XLFormViewController alloc] init];
    return _formController;
}


- (void)forceLoadingOfTheView
{
    // This triggers to load the view
    expect(self.formController.view).notTo.beNil();
    self.formController.view.frame = CGRectMake(0, 0, 375, 667);
    [self.formController.view layoutIfNeeded];
//    [self.formController.tableView reloadData];
}


@end
