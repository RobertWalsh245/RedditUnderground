//
//  ThreadTableViewCell.m
//  Reddit UnderGround
//
//  Created by Rob on 10/19/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "ThreadTableViewCell.h"

@implementation ThreadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
