//
//  WebViewController.h
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) NSString *URL;
@property (weak, nonatomic) NSString *ThreadName;
@property (weak, nonatomic) NSString *Subreddit;
@property (strong, nonatomic) UIWebView *wv;
@end
