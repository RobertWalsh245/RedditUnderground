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

@synthesize btnHeader;

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
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo Trimmed White.png"]];
    [img setContentMode:UIViewContentModeScaleAspectFit];
    img.frame = CGRectMake(140,5,40,40);
    
    [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:(45/255.0) green:(45/255.0) blue:(110/255.0) alpha:1] ];
    
    self.navigationItem.titleView = img;
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:img];
   
    
    
    
    //UIBarButtonItem *swapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"link color.png"] style:UIBarButtonItemStylePlain target:self action:@selector(Swap:)];
    
    
    
    
            //self.tblThreads.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tblThreads.bounds.size.width, 0.01f)];
    
    
    self.tblThreads.backgroundView = nil;
    self.tblThreads.backgroundColor = [UIColor  whiteColor];
    
    [self.tblThreads setDelegate:self];
    [self.tblThreads setDataSource:self];
    [self.tblThreads setAllowsSelection:YES];
    
    [self.tblThreads reloadData];
    
    
    /*/ Round corners using CALayer property
    [[self.tblThreads layer] setCornerRadius:10];
    [self.tblThreads setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    [[self.tblThreads layer] setBorderColor:
     //HTML color codes of logo
     //Red Ring = #CF0013 ....... R:207 G:0 B:19
     //Blue #2D2D6E.........R:45 G:45 B:110
     [[UIColor colorWithRed:207.0f/255.0f green:0.0f/255.0f blue:19.0f/255.0f alpha:1.0] CGColor]];
    [[self.tblThreads layer] setBorderWidth:1.75];
    */
    
    //Link array is link regardless of whether reddit or external link
    //Second array of comment thread links matching each above link. For self posts this will be a duplicate.
    //Check if the comment url you are loading is the same as the link (self post) and don't bother loading it.
    //Instead put in NSString flag in array as placeholder and signal for toggle button to do nothing
    //Links array is loaded into table view. When cell is selected corresponding indexpath.row in comments array is animated simultaneously with link.
    //Toggle button on Nav controller swaps the Hidden property of the displayed thread
    
    if ([[DatabaseModel sharedManager] Refresh]) {
        [self SetUpWebViews];
        [self AnimateFirstWebview];
    }
    
//453
}

-(void)AnimateFirstWebview{
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

- (IBAction)TableHeaderTapped:(id)sender {
    //Animate tableview up / down when tapped
    
    if (self.tblThreads.frame.origin.y == 453) {
        //Table view is up, slide down
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                self.tblThreads.frame = CGRectMake(0.0f, self.tblThreads.frame.origin.y +100, self.tblThreads.frame.size.width, self.tblThreads.frame.size.height);
                         
                     }
                     completion:NULL];
        self.btnHeader.frame = CGRectMake(self.btnHeader.frame.origin.x, self.btnHeader.frame.origin.y+100, self.btnHeader.frame.size.width, self.btnHeader.frame.size.height);
        
    }else{
        //tableview is down, slide up
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.tblThreads.frame = CGRectMake(0.0f, self.tblThreads.frame.origin.y -100, self.tblThreads.frame.size.width, self.tblThreads.frame.size.height);
                             
                         }
                         completion:NULL];
        self.btnHeader.frame = CGRectMake(self.btnHeader.frame.origin.x, self.btnHeader.frame.origin.y-100, self.btnHeader.frame.size.width, self.btnHeader.frame.size.height);
        
    }
    
    
}

/*
 [UIView animateWithDuration:1.0f
 delay:0.0f
 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
 animations:^{
 
 
 self.tableView.frame = CGRectMake(0.0f, -self.tableView.frame.size.width, self.tableView.frame.size.width, self.tableView.frame.size.height);
 
 }
 completion:NULL];
 */

//Move this method to singleton
-(void) SetUpWebViews {
    [[[DatabaseModel sharedManager] LoadedWebViews] removeAllObjects];
    [[[DatabaseModel sharedManager] LoadedComments] removeAllObjects];
    RKLink *link;
    //Loop through thread links and load each in a web view
    for (int i = 0; i< [[[DatabaseModel sharedManager] ActiveThreads] count]; i++) {
        
        link = [[DatabaseModel sharedManager] ActiveThreads] [i];
        
        //Create link web view
        UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(500,30,318, 483)];
        wv.delegate = self;
        [wv loadRequest:
         [NSURLRequest requestWithURL:
          link.URL]];
        
        [self.view addSubview: wv];
        wv.scalesPageToFit = YES;
        
        // Round corners using CALayer property
        [[wv layer] setCornerRadius:10];
        [wv setClipsToBounds:YES];
        /*
        // Create colored border using CALayer property
        [[wv layer] setBorderColor:
         
         [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
        [[wv layer] setBorderWidth:1.75];
        */
        
        
        [[[DatabaseModel sharedManager] LoadedWebViews] addObject:wv];
        
        // Create Comment web view
        //If this is a comment thread
        if ([[link.URL path] isEqualToString:[link.permalink path]]) {
            //Don't double load thread. Place flag in array instead
            [[[DatabaseModel sharedManager] LoadedComments] addObject:@"NO"];
        }else{
            //It's a regular link. Load a web view and place it in the comments array
            UIWebView *wv2 = [[UIWebView alloc] initWithFrame:CGRectMake(500,30,318, 483)];
            wv2.delegate = self;
            [wv2 loadRequest:
             [NSURLRequest requestWithURL:
              link.permalink]];
            
            [self.view addSubview: wv2];
            wv2.scalesPageToFit = YES;
           //Scale comments to hide side bar
            [wv2 stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 10.0;"];
            
            
            // Round corners using CALayer property
            [[wv2 layer] setCornerRadius:10];
            [wv2 setClipsToBounds:YES];
            /*
            // Create colored border using CALayer property
            [[wv2 layer] setBorderColor:
             
             [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
            [[wv2 layer] setBorderWidth:1.75];
             */
             
            [self.view sendSubviewToBack:wv2];
            
            [[[DatabaseModel sharedManager] LoadedComments] addObject:wv2];
        }
    }
    
    
}

- (void)ChangeSwapButton: (NSString *) BtnType {
    //Change the nav bar button based on given string
    
        UIButton *swapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [swapButton addTarget:self action:@selector(Swap:) forControlEvents:UIControlEventTouchUpInside];
        swapButton.bounds = CGRectMake( 0, 0, 40, 40 );
    
    if ([BtnType isEqualToString:@"Link"]) {
        UIImage *faceImage = [UIImage imageNamed:@"link color.png"];
        [swapButton setImage:faceImage forState:UIControlStateNormal];
        UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:swapButton ];
        self.navigationItem.rightBarButtonItem = faceBtn;
    }else if ([BtnType isEqualToString:@"Comment"]) {
        UIImage *faceImage = [UIImage imageNamed:@"comment color.png"];
        [swapButton setImage:faceImage forState:UIControlStateNormal];
        UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:swapButton ];
        self.navigationItem.rightBarButtonItem = faceBtn;
    }else{
        //No button
          self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)ToggleSwapButton {
     UIWebView *wv;
    
    //Find displayed thread
    for (int i = 0; i < [[[DatabaseModel sharedManager] LoadedWebViews] count]; i++) {
        wv =[[DatabaseModel sharedManager] LoadedWebViews][i];
        //If Link wv is displayed
        if (wv.frame.origin.x == 1) {
            //Check if this is a string aka has no comments
            if ([[[DatabaseModel sharedManager] LoadedComments][i] isKindOfClass:[NSString class]]) {
                //Remove Barbutton
                [self ChangeSwapButton:@""];
            }else{ //It's a link with comments
                if (wv.hidden) { //If the link is hidden we want the button to be a link
                    [self ChangeSwapButton:@"Link"];
                }else{
                    [self ChangeSwapButton:@"Comment"];
                }
            }
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
                //Remove Barbutton
                [self ChangeSwapButton:@""];
            }else{
                //It is a webview it has comments
                cwv =[[DatabaseModel sharedManager] LoadedComments][i];
                
                //If the WV is the top view
                if ([[self.view subviews] indexOfObject:wv] > [[self.view subviews] indexOfObject:cwv]) {
                    
                    cwv.hidden = NO;
                    //Unhide
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    [cwv setAlpha:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [self.view bringSubviewToFront:cwv];
                    [cwv setAlpha:1];
                    
                    [UIView commitAnimations];
                    
                    //Change barbutton to opposite symbol
                    [self ChangeSwapButton:@"Link"];
                    
                    
                }else{
                    
                    wv.hidden = NO;
                    //Unhide
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    [wv setAlpha:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [self.view bringSubviewToFront:wv];
                    [wv setAlpha:1];
                    
                    [UIView commitAnimations];
                    
                    //Change barbutton to opposite symbol
                    [self ChangeSwapButton:@"Comment"];
                    
                }
                //Bring Tableview to front
                [self.view bringSubviewToFront:self.tblThreads];
                [self.view bringSubviewToFront:self.btnHeader];
            }
        }
    }
    
}


-(void)AnimateWebView: (UIWebView *) wv OntoScreen: (bool)Display{
    
    if (Display) {
        //Animate wv onto screen
        [UIView animateWithDuration:0.4 animations:^{
            wv.frame = CGRectMake(1, 67, wv.frame.size.width, wv.frame.size.height);
        }];

        
    }else{
        //Animate wv to the left off screen then back to the right
        [UIView animateWithDuration:0.3 animations:^{
            wv.frame = CGRectMake(-500,30,wv.frame.size.width, wv.frame.size.height);
            
        }
            completion:^(BOOL finished){
                if (finished) {
                    wv.frame = CGRectMake(500,30,wv.frame.size.width, wv.frame.size.height);
                             }
        }];
       
    }
    
    //Bring Tableview to front
    [self.view bringSubviewToFront:self.tblThreads];
    [self.view bringSubviewToFront:self.btnHeader];
    
    [self ToggleSwapButton];
    
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
    
    //Dictate which section
    
    UITableViewHeaderFooterView* header =[self.tblThreads headerViewForSection:indexPath.section];
   header.textLabel.text;
    
        //NSLog(webview.URL);
    NSMutableString *mutString = [[NSMutableString alloc]init];
    [mutString appendString:[NSString stringWithFormat:@"%d", indexPath.row + 1]];
    [mutString appendString:@". "];
    [mutString appendString: link.subreddit];
        cell.lblThreadName.text = link.title;
        cell.lblSubredditName.text = mutString;
        //Set image
        //cell.Image.image = subreddit
    /*
    UIWebView *wv;
    NSString *currentURL;
    //Hide check mark
    //Loop loaded threads
    for (int i = 0; i< [[[DatabaseModel sharedManager] LoadedWebViews ] count]; i++) {
        wv = [[DatabaseModel sharedManager] LoadedWebViews][i];
        currentURL = [wv stringByEvaluatingJavaScriptFromString:@"window.location"];
        //If the URL associated with this cell matches the one loaded in the web view
        if ([currentURL isEqualToString:link.URL]) {
            //we want this web view
            break;
        }
    }
    
    //If this wv is displayed
    if (wv.frame.origin.x == 1) {
        cell.check.hidden = NO;
    }else{
        cell.check.hidden = YES;
    }
    */
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //HTML color codes of logo
    //Red Ring = #CF0013 ....... R:207 G:0 B:19
    //Blue #2D2D6E.........R:45 G:45 B:110
    
    // Background color
    view.tintColor = [UIColor colorWithRed:(45/255.0) green:(45/255.0) blue:(110/255.0) alpha:1] ;
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + 10);

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
   // NSLog(@"Links array has %lu",(unsigned long)[[[DatabaseModel sharedManager] LoadedWebViews] count]);
   // NSLog(@"Comments array has %lu",(unsigned long)[[[DatabaseModel sharedManager] LoadedComments] count]);
    
    ThreadTableViewCell *c;
    
    
    
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
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // return [[[DatabaseModel sharedManager] SelectedSubreddits] count];
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [[DatabaseModel sharedManager] SelectedSubreddits] [section];
    return @"Threads";
}

- (void)dealloc {   /*/Remove delegates of web views
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
