//
//  RedditUnderGroundViewController.m
//  Reddit UnderGround
//
//  Created by Rob on 9/13/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "RedditUnderGroundViewController.h"
#import "DatabaseModel.h"
#import "ThreadsViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>

@interface RedditUnderGroundViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblReddits;

//HTML color codes of logo
//Red Ring = #CF0013 ....... R:207 G:0 B:19
//Blue #2D2D6E.........R:45 G:45 B:110
//Reddit eye #ED1C00

//Logo Orig aspect ratio 446 width 390 height

@property (nonatomic, strong) NSDecimalNumber *previous;
@property (nonatomic, strong) NSDecimalNumber *current;
@property (nonatomic) NSUInteger position;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation RedditUnderGroundViewController
@synthesize btnGoToThreads;
@synthesize lblTitle;
@synthesize btnLoad;
@synthesize imgLoad;
@synthesize lblStatus;
bool NeedSubreddits;
int Searching;
int Returned;
@synthesize swtRefresh;
@synthesize lblOr;
@synthesize btnLoadFrontPage;
@synthesize lblThreads;
@synthesize SettingsView;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize tblReddits = _tblReddits;

-(ThreadsViewController *) threadsviewcontroller{
    if (!_ThreadsViewController) {
        _ThreadsViewController = [[ThreadsViewController alloc]init];
    }
    return _ThreadsViewController;
}
-(UISlider *) sldThreads{
    if (!_sldThreads) {
        _sldThreads = [[UISlider alloc]init];
    }
    return _sldThreads;
}

-(UITableView *) tblReddits{
    if (!_tblReddits) {
        _tblReddits = [[UITableView alloc]init];
    }
    return _tblReddits;
}

@synthesize SubscribedSubreddits = _SubscribedSubreddits;
-(NSMutableArray *)subscribedSubreddits //Lazy instantiation of database model
{
    if (!_SubscribedSubreddits) {
        _SubscribedSubreddits = [[NSMutableArray alloc]init];
    }
    return _SubscribedSubreddits;
}
@synthesize CheckedCells = _CheckedCells;
-(NSMutableArray *)CheckedCells //Lazy instantiation of database model
{
    if (!_CheckedCells) {
        _CheckedCells = [[NSMutableArray alloc]init];
    }
    return _CheckedCells;
}

@synthesize ActiveTabs = _ActiveTabs;
-(NSMutableArray *)ActiveTabs //Lazy instantiation of database model
{
    if (!_ActiveTabs) {
        _ActiveTabs = [[NSMutableArray alloc]init];
    }
    return _ActiveTabs;
}
-(NSMutableDictionary * ) LinksDictionary //Lazy instantiation of database model
{
    if (!_LinksDictionary) {
        _LinksDictionary = [[NSMutableDictionary alloc]init];
    }
    return _LinksDictionary;
}
@synthesize SelectedSubreddits = _SelectedSubreddits;
-(NSMutableArray *)SelectedSubreddits //Lazy instantiation of database model
{
    if (!_SelectedSubreddits) {
        _SelectedSubreddits = [[NSMutableArray alloc]init];
    }
    return _SelectedSubreddits;
}

- (void) viewWillAppear:(BOOL)animated{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBar.hidden = YES;
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.backgroundTask = UIBackgroundTaskInvalid;
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:20
                                                        target:self
                                                      selector:@selector(RefreshThreads)
                                                      userInfo:nil
                                                       repeats:YES];
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    
  // self.tabBarController.tabBar.hidden = YES;
    
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.SettingsView addGestureRecognizer:tap];

    
    // Round corners using CALayer property
    [[self.SettingsView layer] setCornerRadius:10];
    [self.SettingsView setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    
    //self.SettingsView.layer.borderColor = [UIColor colorWithRed:255 green:45 blue:110 alpha:1.0].CGColor;
    
    
    // Create colored border using CALayer property
    [[self.SettingsView layer] setBorderColor:
     
     [[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:110.0f/255.0f alpha:1.0] CGColor]];
    [[self.SettingsView layer] setBorderWidth:5];
    
    //[[self.SettingsView layer] setBorderColor:
     //HTML color codes of logo
     //Red Ring = #CF0013 ....... R:207 G:0 B:19
     //Blue #2D2D6E.........R:45 G:45 B:110
   //  [[UIColor colorWithRed:45 green:45 blue:110 alpha:1.0] CGColor]];
    
    
    //[[self.SettingsView layer] setBackgroundColor:
     //HTML color codes of logo
     //Red Ring = #CF0013 ....... R:207 G:0 B:19
     //Blue #2D2D6E.........R:45 G:45 B:110
     //[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]];
    
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [[UINavigationBar appearance] setTintColor:[UIColor scrollViewTexturedBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIColor blackColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-Small@2x.png"]];
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    lblTitle.font = [UIFont fontWithName:@"rocko-flf" size:28];
    lblOr.font = [UIFont fontWithName:@"rocko-flf" size:16];
    btnLoad.font = [UIFont fontWithName:@"rocko-flf" size:16];
    btnLoadFrontPage.font = [UIFont fontWithName:@"rocko-flf" size:16];
    btnGoToThreads.font = [UIFont fontWithName:@"rocko-flf" size:16];
    
    RKSubreddit *subreddit;
    
    self.SubscribedSubreddits = [NSMutableArray arrayWithObjects: subreddit, nil];
    
    
    NeedSubreddits = YES;

       //register to listen for event
    [[NSNotificationCenter defaultCenter]
    addObserver:self
     selector:@selector(SignedInWasNotified:)
     name:@"signedin"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(SignInFailedWasNotified:)
     name:@"signinfailed"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(SubredditsRetrievedWasNotified:)
     name:@"subredditsretrieved"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RetrievedLinksWasNotified:)
     name:@"retrievedlinks"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(FrontPageRetrievedWasNotified:)
     name:@"frontpageretrieved"
     object:nil ];
    
    //Log into reddit
    //If there are no saved user details
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] == nil) {
        //Login as the default profile
        [self LogIntoRedditWithUser: @"RedditUNDG" WithPassword:@"London12"];
    }else{
        //Log in as the saved username/pword
        [self LogIntoRedditWithUser: [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] WithPassword:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        //Set txtboxes with info
        txtUsername.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    
    //Set Refresh
    BOOL refresh = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Refresh"] boolValue];
    if (refresh) {
        [swtRefresh setOn:YES animated:NO];
    }else{
        [swtRefresh setOn:NO animated:NO];
    }
    
    
    
    //Set Number of threads
    [self LoadThreadsSettings];
    
    
    [self.tblReddits setDelegate:self];
    [self.tblReddits setDataSource:self];
    [self.tblReddits setAllowsSelection:YES];
    
}



-(void)LogIntoRedditWithUser: (NSString*) user WithPassword: (NSString*) password  {
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    
    lblStatus.text = @"Logging into Reddit...";
    
    
    //if There is a user signed in
    if ([[RKClient sharedClient] isSignedIn]) {
        //If that user doesn't match who we want to be signed in
        if (![[RKClient sharedClient].currentUser.username isEqualToString:user]) {
            //Log out the current user
            [[RKClient sharedClient] signOut];
            NSLog(@"Attempting to sign in as %@", user);
            //Sign in
            [[RKClient sharedClient] signInWithUsername:user password:password completion:^(NSError *error) {
                if (!error)
                {
                    NSLog(@"Successfully signed in as %@", user);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"signedin" object:self];
            
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"signinfailed" object:self];
                }
        
                }];
            
                }
    }else{
        //There is no user signed in. Sign in
        NSLog(@"Attempting to sign in as %@", user);
        //Sign in
        [[RKClient sharedClient] signInWithUsername:user password:password completion:^(NSError *error) {
            if (!error)
            {
                NSLog(@"Successfully signed in as %@", user);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"signedin" object:self];
                
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"signinfailed" object:self];
            }
            
        }];
        
    }
    
}

-(void)GetSubscribedSubreddits {
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    
    lblStatus.text = @"Retrieving Subreddit information...";
    [self.SubscribedSubreddits removeAllObjects];
    
    //Log in if we are not signed into reddit
    if(![RKClient sharedClient].isSignedIn) {
        [self LogIntoRedditWithUser: @"RedditUNDG" WithPassword:@"London12"];
    }
    //Get Subscribed subreddits
    [[RKClient sharedClient] subscribedSubredditsWithCompletion:^(NSArray *subreddits, RKPagination *pagination, NSError *error) {
        for (int i=0; i<[subreddits count]; i++) {
                [[self SubscribedSubreddits] addObject:subreddits[i]];
                [[self CheckedCells] addObject:@"NO"]; //Cell is not checked when first added
                NeedSubreddits = NO;
            }
        
        if ([self.SubscribedSubreddits count] >0) {
            NSLog(@"Subscribed Subreddits %d", [self.subscribedSubreddits count]);
           // NSLog(@"Subreddits: %@", subreddits);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"subredditsretrieved" object:self];
        }else{
            NSLog(@"No subreddits retrieved :(");
        }
        
        
    }];
    
}

-(void)GetTopLinksOfSubreddit: (NSString*) subredditName {
    
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
        //Tell user you are loading the subreddit data
    
    
    
    
    
    //Check to see if subreddit already in dictionary
        if([[self LinksDictionary] objectForKey:subredditName] == nil) {
            //The subreddit does not exist in our dictionary
           //Get links for subreddit
            //Deactivate Load button
            [self.btnLoad setEnabled:NO];

            //Add 1 to the count of reddits searching for links
            Searching++;
           
            NSMutableString *mutString;
            mutString = [NSMutableString stringWithString: @"Fetching top links from /r/"];
            [mutString appendString:subredditName];
            [mutString appendString:@"..."];
            lblStatus.text = mutString;
            
        [[RKClient sharedClient] linksInSubredditWithName:subredditName pagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
            NSLog(@"Retrieved %lu Links from /r/%@: ",(unsigned long)[links count], subredditName);
            
            NSMutableString *mutString2;
            mutString2 = [NSMutableString stringWithString: @"Retrieved links from /r/"];
            [mutString2 appendString:subredditName];
            
            lblStatus.text = mutString2;
            
            // Add subreddit links to dictionary
            //subredditName = Key, links = Object to store
            self.LinksDictionary[subredditName] = links;
            Returned++;
            
            if (Searching == Returned) {
            //Reactivate Load Button
            [self.btnLoad setEnabled:YES];
            }
           
            }];

        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) RefreshThreads {
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    
    //Check if refresh is enabled
    BOOL refresh = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Refresh"] boolValue];
    if (refresh) {

    
    NSLog(@"Refreshing Threads");
    [self PopulateLinks];
    
    if ([[[DatabaseModel sharedManager] ActiveThreads] count] > 0) {
        ThreadsViewController *threadsViewController;
        self.ThreadsViewController = threadsViewController;
        self.ThreadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
        
        [[DatabaseModel sharedManager] setRefresh:NO];
        [self.ThreadsViewController SetUpWebViews];
        [self.ThreadsViewController AnimateFirstWebview];
        [self.navigationController pushViewController:self.ThreadsViewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
        self.btnGoToThreads.hidden = NO;
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
        
    }else{
        //We don't have any threads. Don't load next view. Tell user
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something went wrong when trying to load from the selected subreddits.  Please wait a minute then try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        //[alert show];
        
    }
    }
    
}

-(void)PopulateLinks {
    [[[DatabaseModel sharedManager] ActiveThreads] removeAllObjects];
    
    RKLink *link;
    
    //For each selected subreddit, Create a tab for each top link
    for (int i=0; i<[[[DatabaseModel sharedManager] SelectedSubreddits]  count]; i++) {
        for (int x=0; x<[[DatabaseModel sharedManager] NumberOfThreads]; x++) {
            
            //Access the array of links sitting in the dictionary for the given subreddit and assign the top URL
            link = self.LinksDictionary[[[DatabaseModel sharedManager] SelectedSubreddits] [i]][x];
            //Check if link is a sticky, if it is get a new link to load
            if (link.stickied) {
                //Don't load, instead load an extra thread further down the subreddit
                //Set link as the next thread after the limit specified by the user
                link = self.LinksDictionary[[[DatabaseModel sharedManager] SelectedSubreddits] [i]][[[DatabaseModel sharedManager] NumberOfThreads]];
            }
            NSString *path = [link.URL absoluteString];
            
            //Add this Link to the Threads array to be loaded by the next view controller
            NSLog(path);
            
            //Check if link is nil
            if (!link) {
            }else{
                
                //Check if we already have loaded this one....
                
                
                
                
                [[[DatabaseModel sharedManager] ActiveThreads] addObject:link];
            }
        }
    }
    
}

//Keep seperate array of links that have been loaded in the session
//Allow user to check whether they want to load the top threads or new threads

- (IBAction)LoadPressed:(id)sender {
    
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    
    [self PopulateLinks];
    
    if ([[[DatabaseModel sharedManager] ActiveThreads] count] > 0) {
        ThreadsViewController *threadsViewController;
        self.ThreadsViewController = threadsViewController;
        self.ThreadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
        
        [[DatabaseModel sharedManager] setRefresh:YES];
        [self.navigationController pushViewController:self.ThreadsViewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
        self.btnGoToThreads.hidden = NO;
    }else{
        //We don't have any threads. Don't load next view. Tell user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something went wrong when trying to load from the selected subreddits.  Please wait a minute then try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];

    }
    

    
    
}


- (IBAction)LoadFrontPagePressed:(id)sender {
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    //Get Front page links
    [[RKClient sharedClient] frontPageLinksWithPagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
        
        NSLog(@"Retrieved %lu FrontPage links",(unsigned long)[links count]);
        
        // Add subreddit links to dictionary
        //subredditName = Key, links = Object to store
        self.LinksDictionary[@"frontpage"] = links;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"frontpageretrieved" object:self];
    }];
    
}
-(void)LoadFrontPage {
    
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    
    [[[DatabaseModel sharedManager] ActiveThreads] removeAllObjects];
    
    NSArray *frontpage;
    frontpage = [[self LinksDictionary] objectForKey:@"frontpage"];

    //Add each front page link to the active threads array
    for (int i = 0; i < [frontpage count]; i++) {
        [[[DatabaseModel sharedManager] ActiveThreads] addObject:frontpage[i]];
    }
    if ([[[DatabaseModel sharedManager] ActiveThreads] count] > 0) {
        ThreadsViewController *threadsViewController;
        self.ThreadsViewController = threadsViewController;
        self.ThreadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
        
        [[DatabaseModel sharedManager] setRefresh:YES];
        [self.navigationController pushViewController:self.ThreadsViewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
        self.btnGoToThreads.hidden = NO;
        
    }else{
        //We don't have any threads. Don't load next view. Tell user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something went wrong when trying to load from the selected subreddits.  Please wait a minute then try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }

}

- (IBAction)ThreadsPressed:(id)sender {
    //Check if we have threads loaded, if so push the vc
    if (self.ThreadsViewController != nil) {
        //self.ThreadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
        [self.navigationController pushViewController:self.ThreadsViewController animated:YES];
        [[DatabaseModel sharedManager] setRefresh:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }
    
    
}

//////////////Table View Methods //////////////////
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubredditTableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (networkReachable()==NO) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self DisplayNetworkAlert];
        return;
    }

        //If the cell is not checked
        if ([self.CheckedCells[indexPath.row] isEqualToString:@"NO"]) {
            //Limit to 5 selected subreddits
            if ([[[DatabaseModel sharedManager] SelectedSubreddits] count] < 5) {
                //Tag as checked
                self.CheckedCells[indexPath.row] = @"YES";
                //Add the subreddit name from the selected cell to our selected array
                [[[DatabaseModel sharedManager] SelectedSubreddits]  addObject:cell.lblSubredditName.text];
                [self GetTopLinksOfSubreddit:cell.lblSubredditName.text];
            }
        }else{
            //Tag as unchecked
            self.CheckedCells[indexPath.row] = @"NO";
            //Remove the subreddit name from the selected cell from our selected array
            NSInteger count = [[[DatabaseModel sharedManager] SelectedSubreddits]  count];
            for (NSInteger index = (count - 1); index >= 0; index--) {
                if ([[[DatabaseModel sharedManager] SelectedSubreddits] [index] isEqualToString:cell.lblSubredditName.text]) {
                    [[[DatabaseModel sharedManager] SelectedSubreddits]  removeObjectAtIndex:index];
                }
            }
        }
    [self.tblReddits reloadData];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubredditTableViewCell *cell = (SubredditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"subreddit"];
    RKSubreddit *subreddit;
    
    subreddit = self.SubscribedSubreddits[indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"identifier"];
    }
    
   // NSLog(@"Subscribed Subreddits: %lu",(unsigned long)[self.SubscribedSubreddits count]);
  //  NSLog(subreddit.name);
    
    if ([self.CheckedCells[indexPath.row] isEqualToString:@"YES"]) {
        cell.image.hidden = NO;
    }else{
        cell.image.hidden = YES;
    }
    
    cell.lblSubredditName.text = subreddit.name;
    //Set image
    //cell.Image.image = subreddit
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{//within tbl search need to return different
    return [self.SubscribedSubreddits count];
    //return 1;
}

/////////Settings Methods//////////
- (IBAction)SettingsPressed:(id)sender {
    //Toggle diaply of settings view
    
    //If settings is hidden off screen
    if (self.SettingsView.frame.origin.y == 1000) {
        //Animate view onto screen
        [UIView animateWithDuration:0.4 animations:^{
        self.SettingsView.frame = CGRectMake(5, 185, 310, 441);
        }];
    }else{
        //Animate off screen
        [UIView animateWithDuration:0.4 animations:^{
            self.SettingsView.frame = CGRectMake(5, 1000, 310, 441);
        }];
    }
    
    
}
- (IBAction)RefreshToggled:(id)sender {
    //Set User default
    //Commit details to NS User defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //Check if refresh is enabled
    bool refresh = swtRefresh.isOn;

    [userDefaults setObject:[NSNumber numberWithBool:refresh] forKey:@"Refresh"];
    [userDefaults synchronize];
    NSLog(swtRefresh.isOn ? @"Refresh set to on" : @"Refresh set to off");
}

- (IBAction)LogInPressed:(id)sender {
    if (networkReachable()==NO) {
        [self DisplayNetworkAlert];
        return;
    }
    //Check txt boxes have entered text
    if (txtPassword.text.length > 0 && txtUsername.text.length > 0) {
        //Try to log in with the entries
        [self LogIntoRedditWithUser:txtUsername.text WithPassword:txtPassword.text];
    }
    
    //Commit details to NS User defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:txtUsername.text forKey:@"username"];
    [userDefaults setObject:txtPassword.text forKey:@"password"];
    [userDefaults synchronize];
    
}

-(void)dismissKeyboard{
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
}


- (IBAction)threadsValueChanged:(id)sender {
    //Update the # of threads to load label and property
    //Convert float to int
    int intValue = roundl(self.sldThreads.value);
    NSString *str = [NSString stringWithFormat:@"%d", intValue];
    lblThreads.text = str;
    [[DatabaseModel sharedManager] setNumberOfThreads:self.sldThreads.value];
    //Commit details to NS User defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:str forKey:@"numberofthreads"];
    [userDefaults synchronize];
}


-(void) LoadThreadsSettings {
    //Set Number of threads
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"numberofthreads"] == nil) {
        //Set up with default value of 3
        //Update the # of threads to load label and property
        self.sldThreads.value = 3;
        int intValue = roundl(self.sldThreads.value);
        NSString *str = [NSString stringWithFormat:@"%d", intValue];
        lblThreads.text = str;
        [[DatabaseModel sharedManager] setNumberOfThreads:self.sldThreads.value];
        //Commit details to NS User defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:str forKey:@"numberofthreads"];
        [userDefaults synchronize];
        
    }else{
        //Set their defaults
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberofthreads"];
        float flt = [str floatValue];
        self.sldThreads.value = flt;
        lblThreads.text = str;
        [[DatabaseModel sharedManager] setNumberOfThreads:flt];
    }
}




///////////event handlers fired upon notifications///////////
-(void)SignedInWasNotified: (NSNotification *) notification
{
    NSLog(@"Sign in was notified");
    lblStatus.text = @"Login succesful";
    //Flag whether we are logged in default or as a custom user
    if ([[RKClient sharedClient].currentUser.username isEqualToString:@"RedditUNDG"]) {
        //[[DatabaseModel sharedManager]
        
    }
    
    if (NeedSubreddits) {
        [self GetSubscribedSubreddits];
    }
}
-(void)SignInFailedWasNotified: (NSNotification *) notification
{
    NSLog(@"Sign in failed");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to log into Reddit.  Check that your username and password are correct on the settings tab" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    //Log in as default user
    //[self LogIntoRedditWithUser: @"RedditUNDG" WithPassword:@"London12"];
}
-(void)SubredditsRetrievedWasNotified: (NSNotification *) notification
{
    NSLog(@"Subreddits Retrieved was notified");
    [self.tblReddits reloadData];
    //Stop loading wheel
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
    //Hide load things
    self.lblStatus.text = @"Subreddits retrieved";
    self.imgLoad.hidden = YES;
    
    //If settings is hidden off screen animate otherwise just display
   // if (self.SettingsView.frame.origin.y == 1000) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.5];
        [self.tblReddits setAlpha:0];
        [self.btnLoad setAlpha:0];
        //[self.btnLoadFrontPage setAlpha:0];
        [self.lblOr setAlpha:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
        [self.lblOr setHidden:NO];
        [self.lblOr setAlpha:1];
       // [self.btnLoadFrontPage setHidden:NO];
      //  [self.btnLoadFrontPage setAlpha:1];
        [self.tblReddits setHidden:NO];
        [self.tblReddits setAlpha:1];
        [self.btnLoad setHidden:NO];
        [self.btnLoad setAlpha:1];
    
        [UIView commitAnimations];
    
   // }else{
    //    [self.tblReddits setHidden:NO];
    //    [self.btnLoad setHidden:NO];
   // }

    
    
    
    
}
-(void)RetrievedLinksWasNotified: (NSNotification *) notification
{
    NSLog(@"Retrieved Links was notified");
    
}
-(void)FrontPageRetrievedWasNotified: (NSNotification *) notification
{
    NSLog(@"Front Page Retrieved was notified");
    [self LoadFrontPage];
}


-(void) DisplayNetworkAlert {
    
}
BOOL networkReachable()
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *) &zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
            // if target host is not reachable
            return NO;
        }
        
        if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
            // if target host is reachable and no connection is required
            //  then we'll assume (for now) that your on Wi-Fi
            return YES; // This is a wifi connection.
        }
        
        
        if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0)
             ||(flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
            // ... and the connection is on-demand (or on-traffic) if the
            //     calling application is using the CFSocketStream or higher APIs
            
            if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                // ... and no [user] intervention is needed
                return YES; // This is a wifi connection.
            }
        }
        
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
            // ... but WWAN connections are OK if the calling application
            //     is using the CFNetwork (CFSocketStream?) APIs.
            return YES; // This is a cellular connection.
        }
    }
    
    return NO;
}


@end
