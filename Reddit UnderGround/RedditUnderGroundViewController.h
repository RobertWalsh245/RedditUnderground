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
#import "ThreadsViewController.h"
@interface RedditUnderGroundViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnGoToThreads;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoad;
@property (strong, nonatomic) IBOutlet UILabel *lblThreads;
@property (strong, nonatomic) IBOutlet UISlider *sldThreads;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;

@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnLoadFrontPage;
@property(strong, nonatomic)NSMutableArray *SubscribedSubreddits;
@property(strong, nonatomic)NSMutableArray *SelectedSubreddits;
@property(strong, nonatomic)NSMutableArray *CheckedCells;
@property(strong, nonatomic)NSMutableArray *ActiveTabs;
@property(strong, nonatomic)NSMutableDictionary *LinksDictionary;
@property (strong, nonatomic) IBOutlet UIButton *btnLoad;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UISwitch *swtRefresh;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIView *SettingsView;

@property (nonatomic, strong) ThreadsViewController *ThreadsViewController;

@end
