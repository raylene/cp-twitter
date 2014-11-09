//
//  ProfileViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/8/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (nonatomic, strong) NSArray *tweets;

@property (weak, nonatomic) TweetCell *prototypeTweetCell;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // To replace with the user this profile is for
    self.user = [User currentUser];
    [self setupHeader];
    [self setupStats];
    [self setupTweets];

    // Can I setup the giant scroll view programmatically?
    [self setupContainerScrollView];
}

# pragma mark Private helper methods

- (void)setupContainerScrollView {
//    self.containerScrollView = [[UIScrollView alloc] init];
//    self.containerScrollView.bounds = self.view.bounds;
//    
//    [self.view addSubview:self.containerScrollView];
//    [self.containerScrollView addSubview:self.headerView];
//    [self.containerScrollView addSubview:self.tweetTableView];
}

- (void)setupHeader {
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
}

- (void)setupStats {
//    self.tweetCountLabel.text = ;
//    self.followingCountLabel.text = ;
//    self.followerCountLabel.text = ;
    
}

- (void)setupTweets {
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
        
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweetTableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    // TODO: replace with real data!
    self.tweets = [[NSArray alloc] init];
}

#pragma mark - UITableView methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
//   self.prototypeTweetCell.tweet = self.tweets[indexPath.row];
//    CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
//    cell.tweet = self.tweets[indexPath.row];
    cell.parentVC = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
//    vc.tweet = self.tweets[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
