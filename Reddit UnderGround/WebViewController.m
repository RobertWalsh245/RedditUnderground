//
//  WebViewController.m
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize URL;
-(UIWebView *) wv{
    if (!_wv) {
        _wv = [[UIWebView alloc]init];
    }
    return _wv;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    
    
    [self.view addSubview:self.wv];
    
    self.wv.scalesPageToFit = YES;
    
    /*UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor whiteColor];
	self.view = contentView;
	//[contentView release];
    
    UIWebView *webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,517)];
    NSString *url=URL;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
    webview.scalesPageToFit = YES; */

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   /* // Do any additional setup after loading the view.
     UIWebView *webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,517)];
    NSString *url=URL;
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
    */
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
