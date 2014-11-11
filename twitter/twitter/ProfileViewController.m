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
#import "TwitterClient.h"
#import "SVProgressHUD.h"
#import "TweetDetailViewController.h"

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
@property (weak, nonatomic) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) NSArray *tweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [self setupHeader];
    [self setupStats];
    [self setupTweets];

    // TODO: how do you create a ScrollView that includes both the header and the table?
    [[self navigationItem] setTitle:@"Profile"];
}

# pragma mark Private helper methods

- (void)setupHeader {
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:self.user.preferredBackgroundImageUrl]];
    self.nameLabel.text = self.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
}

- (void)setupStats {
    self.tweetCountLabel.text = [self getStatString:self.user.statusesCount];
    self.followingCountLabel.text = [self getStatString:self.user.friendsCount];
    self.followerCountLabel.text = [self getStatString:self.user.followersCount];
}

- (NSString *)getStatString:(NSNumber *)count {
    if ([count integerValue] > 5000) {
        return [NSString stringWithFormat:@"%dk", (int)([count integerValue]/1000)];
    }
    return [count stringValue];
}

- (void)setupTweets {
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    [self.tweetTableView setHidden:YES];
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweetTableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];

    NSDictionary *params = @{@"user_id": self.user.userID};
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tweetTableView reloadData];
        [self.tweetTableView setHidden:NO];
        [SVProgressHUD dismiss];
    }];
}


#pragma mark - Custom setters

- (TweetCell *)prototypeTweetCell {
    if (_prototypeTweetCell == nil) {
        _prototypeTweetCell = [self.tweetTableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _prototypeTweetCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   self.prototypeTweetCell.tweet = self.tweets[indexPath.row];
    CGSize size = [self.prototypeTweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.parentVC = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
