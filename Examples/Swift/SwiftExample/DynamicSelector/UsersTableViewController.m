//
//  UsersTableViewController.m
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

#import "UsersTableViewController.h"
#import "UserLocalDataLoader.h"
#import "UserRemoteDataLoader.h"
#import "User+Additions.h"

// AFNetworking
#import <AFNetworking/UIImageView+AFNetworking.h>


@interface UserCell : UITableViewCell

@property (nonatomic) UIImageView * userImage;
@property (nonatomic) UILabel * userName;

@end

@implementation UserCell

@synthesize userImage = _userImage;
@synthesize userName  = _userName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userName];
        
        [self.contentView addConstraints:[self layoutConstraints]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Views

-(UIImageView *)userImage
{
    if (_userImage) return _userImage;
    _userImage = [UIImageView new];
    [_userImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 10.0f;
    return _userImage;
}

-(UILabel *)userName
{
    if (_userName) return _userName;
    _userName = [UILabel new];
    [_userName setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userName.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _userName;
}

#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"image": self.userImage,
                              @"name": self.userName};
    
    
    NSDictionary *metrics = @{@"imgSize":@50.0,
                              @"margin" :@12.0};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[image(imgSize)]-[name]"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[image(imgSize)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    return result;
}


@end


@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;

static NSString *const kCellIdentifier = @"CellIdentifier";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    // Enable the pagination
    self.loadingPagingEnabled = YES;
    
    // Support Search Controller
    self.supportSearchController = YES;
    
    [self setLocalDataLoader:[[UserLocalDataLoader alloc] init]];
    [self setRemoteDataLoader:[[UserRemoteDataLoader alloc] init]];
    
    // Search
    [self setSearchLocalDataLoader:[[UserLocalDataLoader alloc] init]];
    [self setSearchRemoteDataLoader:[[UserRemoteDataLoader alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // SearchBar
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    
    // register cells
    [self.searchDisplayController.searchResultsTableView registerClass:[UserCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[UserCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self customizeAppearance];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell *) [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];;
    
    User * user = nil;
    if (tableView == self.tableView){
        user = (User *)[self.localDataLoader objectAtIndexPath:indexPath];
    }
    else{
        user = (User *)[self.searchLocalDataLoader objectAtIndexPath:indexPath];
    }
    
    cell.userName.text = user.userName;
    NSMutableURLRequest* imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:user.userImageURL]];
    [imageRequest setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __typeof__(cell) __weak weakCell = cell;
    [cell.userImage setImageWithURLRequest: imageRequest
                          placeholderImage:[User defaultProfileImage]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       if (image) {
                                           [weakCell.userImage setImage:image];
                                       }
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                   }];
    cell.accessoryType = [[self.rowDescriptor.value formValue] isEqual:user.userId] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User * user = nil;
    if (tableView == self.tableView){
        user = (User *)[self.localDataLoader objectAtIndexPath:indexPath];
    }
    else{
        user = (User *)[self.searchLocalDataLoader objectAtIndexPath:indexPath];
    }
    self.rowDescriptor.value = user;
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Helpers

-(void)customizeAppearance
{
    [[self navigationItem] setTitle:@"Select a User"];
    
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


@end
