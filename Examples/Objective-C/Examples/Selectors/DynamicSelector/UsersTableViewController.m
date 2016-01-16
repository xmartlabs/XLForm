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
#import "HTTPSessionManager.h"

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
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[image(imgSize)]-[name]"
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


@interface UsersTableViewController () <UISearchControllerDelegate>

@property (nonatomic, readonly) UsersTableViewController * searchResultController;
@property (nonatomic, readonly) UISearchController * searchController;

@end

@implementation UsersTableViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;
@synthesize searchController = _searchController;
@synthesize searchResultController = _searchResultController;

static NSString *const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.dataLoader =  [[XLDataLoader alloc] initWithURLString:@"/mobile/users.json" offsetParamName:@"offset" limitParamName:@"limit" searchStringParamName:@"filter"];
    self.dataLoader.delegate = self;
    self.dataLoader.storeDelegate = self;
    self.dataLoader.limit = 4;
    self.dataLoader.collectionKeyPath = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UserCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (!self.isSearchResultsController){
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    else{
        [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
        [self.tableView setScrollIndicatorInsets:self.tableView.contentInset];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchController.searchBar sizeToFit];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell *) [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];;
    
    NSDictionary *dataItem = [self.dataStore dataAtIndexPath:indexPath];
    
    cell.userName.text = [dataItem valueForKeyPath:@"user.name"];
    [cell.userImage setImageWithURL:[NSURL URLWithString:[dataItem valueForKeyPath:@"user.imageURL"]] placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    
    cell.accessoryType = [[self.rowDescriptor.value valueForKeyPath:@"user.id"] isEqual:[dataItem valueForKeyPath:@"user.id"]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataItem = [self.dataStore dataAtIndexPath:indexPath];
    
    self.rowDescriptor.value = dataItem;
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - XLDataLoaderDelegate

-(AFHTTPSessionManager *)sessionManagerForDataLoader:(XLDataLoader *)dataLoader
{
    return [HTTPSessionManager sharedClient];
}

#pragma mark - UISearchController

-(UISearchController *)searchController
{
    if (_searchController) return _searchController;
    
    self.definesPresentationContext = YES;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self.searchResultController;
    _searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_searchController.searchBar sizeToFit];
    return _searchController;
}


-(UsersTableViewController *)searchResultController
{
    if (_searchResultController) return _searchResultController;
    _searchResultController = [[UsersTableViewController alloc]init];
    _searchResultController.dataLoader.limit = 0; // no paging in search result
    _searchResultController.isSearchResultsController = YES;
    return _searchResultController;
}

@end