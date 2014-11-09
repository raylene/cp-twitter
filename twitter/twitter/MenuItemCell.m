//
//  MenuItemCell.m
//  twitter
//
//  Created by Raylene Yung on 11/8/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuItemCell.h"

@interface MenuItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@end

@implementation MenuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConfig:(NSDictionary *)config {
    _config = config;
    self.itemName.text = config[@"name"];
    
    // TODO: set icon image
}

@end
