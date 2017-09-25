//
//  SubredditTableViewCell.m
//  Reddit UnderGround
//
//  Created by Rob on 9/17/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "SubredditTableViewCell.h"

@implementation SubredditTableViewCell

@synthesize lblSubredditName;
@synthesize image;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selected = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
