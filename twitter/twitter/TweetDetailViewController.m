//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "ComposerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

- (IBAction)onReply:(id)sender;
- (IBAction)onFavorite:(id)sender;
- (IBAction)onRetweet:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
    [self setupNavigationBar];
    [self displayTweet];
    [self setupGestures];
}

- (void)setupNavigationBar {
    [[[self parentViewController] navigationItem] setTitle:@"Tweet"];
    [[[self parentViewController] navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)]];
}

- (void)displayTweet {
    NSLog(@"TweetDetailViewController, displayTweet: %@", self.tweet);
    
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.tweet.originalPoster.profileImageUrl]];
    self.nameLabel.text = self.tweet.originalPoster.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.originalPoster.screenname];
    
    if (self.tweet.isRetweet) {
        if (!self.tweet.originalPoster.name) {
        }
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
    } else {
        self.retweetLabel.text = @"";
    }
    
    self.timestampLabel.text = self.tweet.fullTimestamp;
    self.contentLabel.text = self.tweet.text;

    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", self.tweet.favoriteCount];
    
    [self.retweetButton setEnabled:(!self.tweet.retweeted)];
    [self.favoriteButton setEnabled:(!self.tweet.favorited)];
}

- (void)setupGestures {
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
    [self.thumbImageView addGestureRecognizer:tapGR];
    [self.thumbImageView setUserInteractionEnabled:YES];
}

- (void)onProfileTap:(UIPanGestureRecognizer *)sender {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = self.tweet.originalPoster;
    [self.navigationController pushViewController:pvc animated:YES];
}

// TODO: investigate "Presenting view controllers on detached view controllers is discouraged" warning...
- (IBAction)onReply:(id)sender {
    ComposerViewController *cvc = [[ComposerViewController alloc] init];
    cvc.replyToTweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];

    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onFavorite:(id)sender {
    NSLog(@"Hit FAVORITE button");
    [[TwitterClient sharedInstance] favoriteStatus:self.tweet.originalID completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"Successfully favorited!");
            [self.favoriteButton setEnabled:NO];
            self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", (int)([self.tweet.favoriteCount intValue] + 1)];
            
        }
    }];
}

- (IBAction)onRetweet:(id)sender {
    NSLog(@"Hit RETWEET button");
    [[TwitterClient sharedInstance] retweetStatus:self.tweet.originalID completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"Successfully retweeted!");
            [self.retweetButton setEnabled:NO];
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", (int)([self.tweet.retweetCount intValue] + 1)];
        }
    }];
}
@end
