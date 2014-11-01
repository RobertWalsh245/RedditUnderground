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

@interface RedditUnderGroundViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblReddits;


@end

@implementation RedditUnderGroundViewController
@synthesize lblTitle;
@synthesize btnLoad;
@synthesize imgLoad;
@synthesize lblStatus;
bool NeedSubreddits;
int Searching;
int Returned;

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
    
  // self.tabBarController.tabBar.hidden = YES;
    
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.SettingsView addGestureRecognizer:tap];

    
    // Round corners using CALayer property
    [[self.SettingsView layer] setCornerRadius:10];
    [self.SettingsView setClipsToBounds:YES];
    
    // Create colored border using CALayer property
    [[self.SettingsView layer] setBorderColor:
     
     [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
    [[self.SettingsView layer] setBorderWidth:1.75];
    
    
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [[UINavigationBar appearance] setTintColor:[UIColor scrollViewTexturedBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],UITextAttributeTextColor,
                                               [UIColor blackColor], UITextAttributeTextShadowColor,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    lblTitle.font = [UIFont fontWithName:@"rocko-flf" size:22];
    
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
    
    //Set Number of threads
    [self LoadThreadsSettings];
    
    
    [self.tblReddits setDelegate:self];
    [self.tblReddits setDataSource:self];
    [self.tblReddits setAllowsSelection:YES];
    
}



-(void)LogIntoRedditWithUser: (NSString*) user WithPassword: (NSString*) password  {
   // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
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




//Seperate method for getting a single subreddit, will require another request to reddit

-(void)GetSubscribedSubreddits {
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
    //Deactivate Load button
    [self.btnLoad setEnabled:NO];
    //Tell user you are loading the subreddit data
    
    
    
    //Check to see if subreddit already in dictionary
        if([[self LinksDictionary] objectForKey:subredditName] == nil) {
            //The subreddit does not exist in our dictionary
           //Get links for subreddit
            //Add 1 to the count of reddits searching for links
            Searching++;
            
        [[RKClient sharedClient] linksInSubredditWithName:subredditName pagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
            NSLog(@"Retrieved %lu Links from /r/%@: ",(unsigned long)[links count], subredditName);
            
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
/*
- (void) CreateTabForURL: (NSString*) URL WithTitle: (NSString*) title {
    //Load a webview controller for a provided link
    WebViewController *Tab = [[WebViewController alloc] init];
    // Set a title for each view controller. These will also be names of each tab
    
    
    
    //@"http://www.reddit.com/r/funny/comments/2gl2lm/i_wasnt_shocked_when_a_picture_of_me_made_it_to/.compact"
   // NSString *fullPath = [NSString stringWithFormat:@"http://www.reddit.com%@.compact", URL];
    
    NSLog(@"Creating tab for: %@", URL);
    
    Tab.title = title;
    Tab.URL = URL;
    //Tab.ThreadName
    
    [[[DatabaseModel sharedManager] ActiveTabs] addObject:Tab];
    NSLog(@"Active Tabs: %d", [[[DatabaseModel sharedManager] ActiveTabs] count]);
   
} */



- (void) CreateTabForURL: (RKLink*) Link {
    //Load a webview controller for a provided link
    WebViewController *Tab = [[WebViewController alloc] init];
    // Set a title for each view controller. These will also be names of each tab
    NSString *path = [Link.URL absoluteString];
    
    
    //@"http://www.reddit.com/r/funny/comments/2gl2lm/i_wasnt_shocked_when_a_picture_of_me_made_it_to/.compact"
    // NSString *fullPath = [NSString stringWithFormat:@"http://www.reddit.com%@.compact", URL];
    
    NSLog(@"Creating tab for: %@", Link.URL);
    
    Tab.title = Link.subreddit;
    Tab.URL = path;
    Tab.ThreadName = Link.title;
    
    
    UIWebView *webview =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,517)];
    NSURL *nsurl=[NSURL URLWithString:path];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    
    Tab.wv = webview;
    
    [[[DatabaseModel sharedManager] ActiveTabs] addObject:Tab];
    [self.tabBarController setViewControllers:[[DatabaseModel sharedManager] ActiveTabs]];
    self.tabBarController.selectedIndex = [[[DatabaseModel sharedManager] ActiveTabs] count];
    
}


//Keep seperate array of links that have been loaded in the session
//Allow user to check whether they want to load the top threads or new threads

- (IBAction)LoadPressed:(id)sender {
    
    [[[DatabaseModel sharedManager] ActiveThreads] removeAllObjects];
    
        RKLink *link;
    
    //For each selected subreddit, Create a tab for each top link
    //[self.SelectedSubreddits count]
    for (int i=0; i<[self.SelectedSubreddits count]; i++) {
        
        //change this to while that only breaks after either its loaded the right num of threads or it's search x amount of threads
        int x = 0;
        while (x !=[[DatabaseModel sharedManager] NumberOfThreads]) {
            
        }
        
        
        
        for (int x=0; x<[[DatabaseModel sharedManager] NumberOfThreads]; x++) {
           
        //Access the array of links sitting in the dictionary for the given subreddit and assign the top URL
        link = self.LinksDictionary[self.SelectedSubreddits[i]][x];
        //Check if link is a sticky, if it is get a new link to load
        if (link.stickied) {
            //Don't load, instead load an extra thread further down the subreddit
            //Set link as the next thread after the limit specified by the user
            link = self.LinksDictionary[self.SelectedSubreddits[i]][[[DatabaseModel sharedManager] NumberOfThreads]];
        }
            
            NSString *path = [link.URL absoluteString];
        
            //Add this Link to the Threads array to be loaded by the next view controller
            NSLog(path);
            
            //Check if link is nil
            if (!link) {
            }else{
                [[[DatabaseModel sharedManager] ActiveThreads] addObject:link];
            }
            
    }
        
    }
    
    if ([[[DatabaseModel sharedManager] ActiveThreads] count] > 0) {
        ThreadsViewController *threadsViewController;
        self.ThreadsViewController = threadsViewController;
        self.ThreadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
        
        [[DatabaseModel sharedManager] setRefresh:YES];
        [self.navigationController pushViewController:self.ThreadsViewController animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
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

        //If the cell is not checked
        if ([self.CheckedCells[indexPath.row] isEqualToString:@"NO"]) {
            //Limit to 5 selected subreddits
            if ([self.SelectedSubreddits count] < 5) {
                //Tag as checked
                self.CheckedCells[indexPath.row] = @"YES";
                //Add the subreddit name from the selected cell to our selected array
                [[self SelectedSubreddits] addObject:cell.lblSubredditName.text];
                [self GetTopLinksOfSubreddit:cell.lblSubredditName.text];
            }
        }else{
            //Tag as unchecked
            self.CheckedCells[indexPath.row] = @"NO";
            //Remove the subreddit name from the selected cell from our selected array
            NSInteger count = [self.SelectedSubreddits count];
            for (NSInteger index = (count - 1); index >= 0; index--) {
                if ([self.SelectedSubreddits[index] isEqualToString:cell.lblSubredditName.text]) {
                    [self.SelectedSubreddits removeObjectAtIndex:index];
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
        self.SettingsView.frame = CGRectMake(0, 127, 320, 441);
        }];
    }else{
        //Animate off screen
        [UIView animateWithDuration:0.4 animations:^{
            self.SettingsView.frame = CGRectMake(0, 1000, 320, 441);
        }];
    }
    
    
}

- (IBAction)LogInPressed:(id)sender {
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
    self.lblStatus.hidden = YES;
    self.imgLoad.hidden = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [self.tblReddits setAlpha:0];
    [self.btnLoad setAlpha:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.tblReddits setHidden:NO];
    [self.tblReddits setAlpha:1];
    [self.btnLoad setHidden:NO];
    [self.btnLoad setAlpha:1];
    
    [UIView commitAnimations];
    
    
}
-(void)RetrievedLinksWasNotified: (NSNotification *) notification
{
    NSLog(@"Retrieved Links was notified");
    
}

@end
