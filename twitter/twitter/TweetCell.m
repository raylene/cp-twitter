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
//        NSLog(@"isRetweet: OP: %@, RT: %@", tweet.originalPoster.name, tweet.user.name);
        if (!tweet.originalPoster.name) {
//            NSLog(@"OP data: %@", tweet.originalPoster.dictionary);
        }
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
    } else {
        self.retweetLabel.text = @"";
    }

    //    self.timestampLabel.text = tweet.truncatedCreatedAt;
    self.contentLabel.text = tweet.text;
}

- (IBAction)onReply:(id)sender {
    NSLog(@"Hit REPLY button");
//    ComposerViewController *vc = [[ComposerViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onRetweet:(id)sender {
}

- (IBAction)onFavorite:(id)sender {
}
@end
