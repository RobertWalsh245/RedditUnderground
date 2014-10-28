//
//  WebViewController.h
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *ThreadName;
@property (strong, nonatomic) NSString *Subreddit;
@property (strong, nonatomic) UIWebView *wv;


@end
