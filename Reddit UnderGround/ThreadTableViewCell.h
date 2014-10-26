//
//  ThreadTableViewCell.h
//  Reddit UnderGround
//
//  Created by Rob on 10/19/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblThreadName;
@property (strong, nonatomic) IBOutlet UILabel *lblSubredditName;

@end
