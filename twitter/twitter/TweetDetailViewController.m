//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "ComposerViewController.h"

@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
}

- (IBAction)onReply:(id)sender {
    NSLog(@"Hit REPLY button");
    ComposerViewController *vc = [[ComposerViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:nil];
}

@end
