//
//  RedditUnderGroundViewController.h
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbedViewController.h"
#import "RedditKit.h"
#import "SubredditTableViewCell.h"
@interface RedditUnderGroundViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoad;

@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property(strong, nonatomic)NSMutableArray *SubscribedSubreddits;
@property(strong, nonatomic)NSMutableArray *SelectedSubreddits;
@property(strong, nonatomic)NSMutableArray *CheckedCells;
@property(strong, nonatomic)NSMutableArray *ActiveTabs;
@property(strong, nonatomic)NSMutableDictionary *LinksDictionary;
@property (weak, nonatomic) IBOutlet UIButton *btnLoad;

@end
