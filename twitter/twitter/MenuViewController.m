//
//  MenuViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/8/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "MenuItemCell.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"

int const kProfileItemIndex = 0;
int const kHomeItemIndex = 1;
int const kMentionsItemIndex = 2;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (nonatomic, strong) NSArray *menuItemConfig;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) MenuItemCell *prototypeCell;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self displayUserInfo];
    [self setupMenuTable];
}

- (IBAction)onProfileButtonClick:(id)sender {
}

- (IBAction)onHomeButtonClick:(id)sender {
    
}
- (IBAction)onMentionsButtonClick:(id)sender {

}

#pragma mark - Custom setters

- (MenuItemCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.menuTableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
    }
    return _prototypeCell;
}

# pragma mark Private helper methods

// TODO: figure out how best to share functionality like this
- (void)displayUserInfo {
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
}

- (void)setupMenuTable {
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *menuItemCellNib = [UINib nibWithNibName:@"MenuItemCell" bundle:nil];
    [self.menuTableView registerNib:menuItemCellNib forCellReuseIdentifier:@"MenuItemCell"];
 
    // Init menu item option configurations
    self.menuItemConfig =
        @[
          @{@"name" : @"Profile", @"img": @500},
          @{@"name" : @"Home", @"img": @1000},
          @{@"name" : @"Mentions", @"img": @2000}
          ];
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.config = self.menuItemConfig[indexPath.row];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.config = self.menuItemConfig[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItemConfig.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    if (indexPath.row == kProfileItemIndex) {
        vc = [[ProfileViewController alloc] init];
    } else if (indexPath.row == kHomeItemIndex) {
        vc = [[TweetsViewController alloc] init];
    } else if (indexPath.row == kMentionsItemIndex) {
        vc = [[TweetsViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
