//
//  SubredditTableViewCell.h
//  Reddit UnderGround
//
//  Created by Rob on 9/17/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubredditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubredditName;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) BOOL selected;

@end
