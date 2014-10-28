//
//  SubredditTableViewCell.h
//  Reddit UnderGround
//
//  Created by Rob on 9/17/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubredditTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblSubredditName;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) BOOL selected;

@end
