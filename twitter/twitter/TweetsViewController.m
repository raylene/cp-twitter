//
//  TweetsViewController.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import "ComposerViewController.h"
#import "MenuViewController.h"
#import "SVProgressHUD.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (weak, nonatomic) TweetCell *prototypeTweetCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TweetsViewController

- (TweetsViewController *)init {
    self = [super init];
    self.useHomeTimeline = YES; // default
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TweetsViewController - viewDidLoad");
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [self.tweetTableView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPostSuccess:) name:UserPostSuccessNotification object:nil];
    
    [self setupTableView];
    [self setupRefreshControl];
    [self loadTweets];
}

- (void)setupTableView {
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    self.tweetTableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tweetTableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)loadTweets {
    NSLog(@"loadTweets: %hhd", self.useHomeTimeline);
    if (self.useHomeTimeline) {
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            self.tweets = tweets;
            NSLog(@"Loaded %d tweets!", tweets.count);
            [self.tweetTableView reloadData];
            [self.tweetTableView setHidden:NO];
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
        }];
    } else {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            self.tweets = tweets;
            NSLog(@"Loaded %d tweets!", tweets.count);
            [self.tweetTableView reloadData];
            [self.tweetTableView setHidden:NO];
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
        }];
    }
}

- (IBAction)onMenu:(id)sender {
    [self presentViewController:[[MenuViewController alloc]init] animated:YES completion:nil];
}

- (IBAction)onCompose:(id)sender {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[ComposerViewController alloc] init]];
    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRefresh {
    [self loadTweets];
}

- (void)userPostSuccess:(NSNotification*)notification {
    NSLog(@"userPostSuccess: %@", notification.userInfo);
    NSMutableArray *newTweets = [NSMutableArray arrayWithArray:self.tweets];
    [newTweets insertObject:[[Tweet alloc] initWithDictionary:notification.userInfo] atIndex:0];
    self.tweets = newTweets;
    [self.tweetTableView reloadData];
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
