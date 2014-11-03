//
//  ComposerViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposerViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

int const kMaxCharacters = 140;

@interface ComposerViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composerInput;
@property (weak, nonatomic) IBOutlet UILabel *remainingCharsLabel;


@end

@implementation ComposerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    [self displayUserInfo];
    [self displayResponseText];
    
    self.composerInput.delegate = self;
}

- (void)setupNavigationBar {
    self.title = @"Compose";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onPost:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onPost:)];
}

- (void)displayUserInfo {
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
}

- (void)displayResponseText {
    if (self.replyToTweet != nil) {
        self.composerInput.text = [NSString stringWithFormat:@"@%@ ", self.replyToTweet.originalPoster.screenname];
    }
    [self textViewDidChange:self.composerInput];
}

- (IBAction)onPost:(id)sender {
    NSLog(@"Hit POST button: %@", self.composerInput.text);
    NSString *replyTo = nil;
    if (self.replyToTweet != nil) {
        replyTo = self.replyToTweet.originalID;
    }
    [[TwitterClient sharedInstance] postStatus:self.composerInput.text replyToID:replyTo completion:^(NSDictionary *response, NSError *error) {
        if (response != nil) {
            NSLog(@"Successfully posted!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"Hit CANCEL button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UITextView methods

- (void)textViewDidChange:(UITextView *)textView{
    self.remainingCharsLabel.text = [NSString stringWithFormat:@"Characters remaining: %d", (kMaxCharacters - self.composerInput.text.length)];
}

// http://code.tutsplus.com/tutorials/ios-sdk-uitextview-uitextviewdelegate--mobile-11210
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > kMaxCharacters){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
