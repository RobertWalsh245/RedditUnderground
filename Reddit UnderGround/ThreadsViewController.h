//
//  ThreadsViewController.h
//  Reddit UnderGround
//
//  Created by Rob on 10/19/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseModel.h"
#import "RedditKit.h"
@interface ThreadsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblThreads;

@end
