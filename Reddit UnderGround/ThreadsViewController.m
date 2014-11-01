//
//  ThreadsViewController.m
//  Reddit UnderGround
//
//  Created by Rob on 10/19/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "ThreadsViewController.h"
#import "DatabaseModel.h"
#import "SubredditTableViewCell.h"
#import "WebViewController.h"
#import "ThreadTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@interface ThreadsViewController ()

@end

@implementation ThreadsViewController

-(UITableView *) tblThreads{
    if (!_tblThreads) {
        _tblThreads = [[UITableView alloc]init];
    }
    return _tblThreads;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    UIBarButtonItem *swapButton = [[UIBarButtonItem alloc] initWithTitle:@"Swap" style:UIBarButtonItemStylePlain target:self action:@selector(Swap:)];
    self.navigationItem.rightBarButtonItem = swapButton;
    
    
            //self.tblThreads.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tblThreads.bounds.size.width, 0.01f)];
    
    
    self.tblThreads.backgroundView = nil;
    self.tblThreads.backgroundColor = [UIColor  scrollViewTexturedBackgroundColor];
    
    [self.tblThreads setDelegate:self];
    [self.tblThreads setDataSource:self];
    [self.tblThreads setAllowsSelection:YES];
    
    [self.tblThreads reloadData];
    
    
    // Round corners using CALayer property
    [[self.tblThreads layer] setCornerRadius:10];
    [self.tblThreads setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    [[self.tblThreads layer] setBorderColor:
     
     [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
    [[self.tblThreads layer] setBorderWidth:1.75];
    
    
    //Link array is link regardless of whether reddit or external link
    //Second array of comment thread links matching each above link. For self posts this will be a duplicate.
    //Check if the comment url you are loading is the same as the link (self post) and don't bother loading it.
    //Instead put in NSString flag in array as placeholder and signal for toggle button to do nothing
    //Links array is loaded into table view. When cell is selected corresponding indexpath.row in comments array is animated simultaneously with link.
    //Toggle button on Nav controller swaps the Hidden property of the displayed thread
    
    if ([[DatabaseModel sharedManager] Refresh]) {
        [self SetUpWebViews];
    }
    
    //Display first thread
    UIWebView *FirstThread;
    
    //Check if this is a string
    if ([[[DatabaseModel sharedManager] LoadedComments] count] >0) {
        if ([[[DatabaseModel sharedManager] LoadedComments][0] isKindOfClass:[NSString class]]) {
        }else{
            FirstThread = [[DatabaseModel sharedManager] LoadedComments][0];
            [self AnimateWebView:FirstThread OntoScreen:YES];
        }
    }
    FirstThread = [[DatabaseModel sharedManager] LoadedWebViews][0];
    [self AnimateWebView:FirstThread OntoScreen:YES];
    

}

-(void) SetUpWebViews {
    [[[DatabaseModel sharedManager] LoadedWebViews] removeAllObjects];
    [[[DatabaseModel sharedManager] LoadedComments] removeAllObjects];
    RKLink *link;
    //Loop through thread links and load each in a web view
    for (int i = 0; i< [[[DatabaseModel sharedManager] ActiveThreads] count]; i++) {
        
        link = [[DatabaseModel sharedManager] ActiveThreads] [i];
        
        //Create link web view
        UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(500,30,319, 383)];
        wv.delegate = self;
        [wv loadRequest:
         [NSURLRequest requestWithURL:
          link.URL]];
        
        [self.view addSubview: wv];
        wv.scalesPageToFit = YES;
        
        
        // Round corners using CALayer property
        [[wv layer] setCornerRadius:10];
        [wv setClipsToBounds:YES];
        
        // Create colored border using CALayer property
        [[wv layer] setBorderColor:
         
         [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
        [[wv layer] setBorderWidth:1.75];
        
        [[[DatabaseModel sharedManager] LoadedWebViews] addObject:wv];
        
        // Create Comment web view
        //If this is a comment thread
        if ([[link.URL path] isEqualToString:[link.permalink path]]) {
            //Don't double load thread. Place flag in array instead
            [[[DatabaseModel sharedManager] LoadedComments] addObject:@"NO"];
        }else{
            //It's a regular link. Load a web view and place it in the comments array
            UIWebView *wv2 = [[UIWebView alloc] initWithFrame:CGRectMake(500,30,319, 383)];
            wv2.delegate = self;
            [wv2 loadRequest:
             [NSURLRequest requestWithURL:
              link.permalink]];
            
            [self.view addSubview: wv2];
            wv2.scalesPageToFit = YES;
            wv2.hidden = YES;
            
            // Round corners using CALayer property
            [[wv2 layer] setCornerRadius:10];
            [wv2 setClipsToBounds:YES];
            
            // Create colored border using CALayer property
            [[wv2 layer] setBorderColor:
             
             [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
            [[wv2 layer] setBorderWidth:1.75];
            
            [[[DatabaseModel sharedManager] LoadedComments] addObject:wv2];
        }
    }
    
    
}

- (void)Swap:(UIButton*)sender {
    //Swap between the comments and the link
    UIWebView *wv;
    UIWebView *cwv;

    //Find displayed thread
    for (int i = 0; i < [[[DatabaseModel sharedManager] LoadedWebViews] count]; i++) {
        wv =[[DatabaseModel sharedManager] LoadedWebViews][i];
        //If Link wv is displayed
        if (wv.frame.origin.x == 1) {
            //Check if this is a string aka has no comments
            if ([[[DatabaseModel sharedManager] LoadedComments][i] isKindOfClass:[NSString class]]) {
            }else{
                //It is a webview it has comments
                cwv =[[DatabaseModel sharedManager] LoadedComments][i];
            
                if (wv.hidden) {
                    [self.view bringSubviewToFront:wv];
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.4];
                    [wv setAlpha:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    wv.hidden = NO;
                    [wv setAlpha:1];
                    
                    [UIView commitAnimations];
                    
                    cwv.hidden = YES;
                    
                }else{
                    [self.view bringSubviewToFront:cwv];
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.4];
                    [cwv setAlpha:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    cwv.hidden = NO;
                    [cwv setAlpha:1];
                    
                    [UIView commitAnimations];
                    wv.hidden = YES;
                }
            }
        }
    }
    
}


-(void)AnimateWebView: (UIWebView *) wv OntoScreen: (bool)Display{
    
    if (Display) {
        //Animate wv onto screen
        [UIView animateWithDuration:0.4 animations:^{
            wv.frame = CGRectMake(1, 67, 319, 383);
        }];
    }else{
        //Animate wv to the left off screen then back to the right
        [UIView animateWithDuration:0.3 animations:^{
            wv.frame = CGRectMake(-500,30,319, 383);
            
        }
            completion:^(BOOL finished){
                if (finished) {
                    wv.frame = CGRectMake(500,30,319, 383);
                             }
        }];
    }
}

- (IBAction)ReloadPressed:(id)sender {
    [self.tblThreads reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThreadTableViewCell *cell = (ThreadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"thread"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"identifier"];
    }
    
    // NSLog(@"Subscribed Subreddits: %lu",(unsigned long)[self.SubscribedSubreddits count]);
    //  NSLog(subreddit.name);
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
       RKLink *link;
        
        link = [[DatabaseModel sharedManager] ActiveThreads][indexPath.row];
    
    
        //NSLog(webview.URL);
    NSMutableString *mutString = [[NSMutableString alloc]init];
    [mutString appendString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    [mutString appendString:@". "];
    [mutString appendString: link.subreddit];
        cell.lblThreadName.text = link.title;
        cell.lblSubredditName.text = mutString;
        //Set image
        //cell.Image.image = subreddit
    
    
    return cell;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
   // NSLog(@"Links array has %lu",(unsigned long)[[[DatabaseModel sharedManager] LoadedWebViews] count]);
   // NSLog(@"Comments array has %lu",(unsigned long)[[[DatabaseModel sharedManager] LoadedComments] count]);
    
    bool CommentsExist;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIWebView *wv;
    UIWebView *cwv;
    
    wv =[[DatabaseModel sharedManager] LoadedWebViews][indexPath.row];
    
    //Check if this is a string
    if ([[[DatabaseModel sharedManager] LoadedComments][indexPath.row] isKindOfClass:[NSString class]]) {
        CommentsExist = NO;
    }else{
        //It is a webview
        CommentsExist = YES;
        cwv =[[DatabaseModel sharedManager] LoadedComments][indexPath.row];
    }
    
    
    //If the selected row is not the one already displayed
    if (wv.frame.origin.x !=1) {
        //Animate off displayed wv
        for (int i = 0; i < [[[DatabaseModel sharedManager] LoadedWebViews] count]; i++) {
            wv =[[DatabaseModel sharedManager] LoadedWebViews][i];
            
            //If Link wv is displayed
            if (wv.frame.origin.x == 1) {
                [self AnimateWebView:wv OntoScreen:NO];
            }
            
            //Check if this is a string
            if ([[[DatabaseModel sharedManager] LoadedComments][i] isKindOfClass:[NSString class]]) {
            }else{
                //It is a webview
                cwv =[[DatabaseModel sharedManager] LoadedComments][i];
                //If comment wv is displayed
                if (cwv.frame.origin.x == 1) {
                    [self AnimateWebView:cwv OntoScreen:NO];
                }
            }
            
            
        }
            
    }
    
    //Unhide selected web view
    wv =[[DatabaseModel sharedManager] LoadedWebViews][indexPath.row];
     [self AnimateWebView:wv OntoScreen:YES];
    if (CommentsExist) {
        cwv =[[DatabaseModel sharedManager] LoadedComments][indexPath.row];
        [self AnimateWebView:cwv OntoScreen:YES];
    }
   
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{//within tbl search need to return different
    return [[[DatabaseModel sharedManager] ActiveThreads] count];
    //return 1;
}


- (void)dealloc {
    /*/Remove delegates of web views
    UIWebView *wv;
    for (int i = 0; i< [[[DatabaseModel sharedManager] ActiveThreads] count]; i++) {
        wv = [[DatabaseModel sharedManager] LoadedWebViews][i];
        [wv setDelegate:nil];
        [wv stopLoading];
        
        NSLog(@"Web Views Deallocated: %d",i);
        
        if ([[[DatabaseModel sharedManager] LoadedComments][i] isKindOfClass:[NSString class]]) {
        }else{
        wv = [[DatabaseModel sharedManager] LoadedComments][i];
        [wv setDelegate:nil];
        [wv stopLoading];
            
            
        }
    } */
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
