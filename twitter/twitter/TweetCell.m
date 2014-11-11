//
//  TweetCell.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposerViewController.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

// Action buttons
- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Ensure label stays correct size at initial load
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
    [self.thumbImageView addGestureRecognizer:tapGR];
    [self.thumbImageView setUserInteractionEnabled:YES];
}

// TODO: Don't navigate if you're on this person's profile? Maybe use events?
- (void)onProfileTap:(UIPanGestureRecognizer *)sender {
    NSLog(@"On profile tap!");
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = self.tweet.originalPoster;
    [self.parentVC.navigationController pushViewController:pvc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = self.contentLabel.frame.size.width;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self.thumbImageView setImageWithURL:[NSURL URLWithString:tweet.originalPoster.profileImageUrl]];
    self.nameLabel.text = tweet.originalPoster.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.originalPoster.screenname];

    if (tweet.isRetweet) {
        if (!tweet.originalPoster.name) {
        }
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
    } else {
        self.retweetLabel.text = @"";
    }

    self.timestampLabel.text = tweet.truncatedTimestamp;
    self.contentLabel.text = tweet.text;
    
    [self.retweetButton setEnabled:!tweet.retweeted];
    [self.favoriteButton setEnabled:!tweet.favorited];
}

- (IBAction)onReply:(id)sender {
    ComposerViewController *cvc = [[ComposerViewController alloc] init];
    cvc.replyToTweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.parentVC presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onFavorite:(id)sender {
    NSLog(@"Hit FAVORITE button");
    [[TwitterClient sharedInstance] favoriteStatus:self.tweet.originalID completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"Successfully favorited!");
            [self.favoriteButton setEnabled:NO];
            self.tweet.favorited = YES;
        }
    }];
}

- (IBAction)onRetweet:(id)sender {
    NSLog(@"Hit RETWEET button");
    [[TwitterClient sharedInstance] retweetStatus:self.tweet.originalID completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"Successfully retweeted!");
            [self.retweetButton setEnabled:NO];
            self.tweet.retweeted = YES;
        }
    }];
}

@end
