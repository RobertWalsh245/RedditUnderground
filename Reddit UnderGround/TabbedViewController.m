//
//  TabbedViewController.m
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "TabbedViewController.h"

@interface TabbedViewController ()

@end

@implementation TabbedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)loadView {
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor whiteColor];
	self.view = contentView;
	//[contentView release];

    WebViewController *Web1 = [[WebViewController alloc] init];
    WebViewController *Web2 = [[WebViewController alloc] init];
    
    // Set a title for each view controller. These will also be names of each tab
    Web1.title = @"Web1";
    Web2.title = @"Web2";

    
    // Create an empty tab controller and set it to fill the screen minus the top title bar
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.view.frame = CGRectMake(0, 0, 320, 519);
    
    // Set each tab to show an appropriate view controller
    [tabBarController setViewControllers:
     [NSArray arrayWithObjects: Web1, Web2, nil]];
    
    // Finally, add the tab controller view to the parent view
    [self.view addSubview:tabBarController.view];
    self.tabBarController.delegate = self;
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.tabBarController.selectedIndex = item.tag;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
