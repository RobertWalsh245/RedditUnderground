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


@synthesize tblReddits = _tblReddits;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  // self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
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
     selector:@selector(SubredditsRetrievedWasNotified:)
     name:@"subredditsretrieved"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RetrievedLinksWasNotified:)
     name:@"retrievedlinks"
     object:nil ];
    
    [self LogIntoRedditWithUser: @"RedditUNDG" WithPassword:@"London12"];
   
    
    
    [self.tblReddits setDelegate:self];
    [self.tblReddits setDataSource:self];
    [self.tblReddits setAllowsSelection:YES];
    
    
    
    
    
}



//etrivePictures: (int) amount WithFilter: (NSString*) filter FromController: (NSString*) controller{

-(void)LogIntoRedditWithUser: (NSString*) user WithPassword: (NSString*) password  {
   // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    lblStatus.text = @"Logging into Reddit...";
    
    [[RKClient sharedClient] signInWithUsername:user password:password completion:^(NSError *error) {
        if (!error)
        {
            NSLog(@"Successfully signed in as %@", user);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"signedin" object:self];
        }
        
    }];
    // dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
    
    //Get links for subreddit
        [[RKClient sharedClient] linksInSubredditWithName:subredditName pagination:nil completion:^(NSArray *links, RKPagination *pagination, NSError *error) {
            NSLog(@"Retrieved %lu Links from /r/%@: ",(unsigned long)[links count], subredditName);
            
            // Add subreddit links to dictionary
            //subredditName = Key, links = Object to store
            self.LinksDictionary[subredditName] = links;
            
            //Reactivate Load Button
            [self.btnLoad setEnabled:YES];
        }];
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



-(void)UpdateLinksOfSelections {
        // Loop through library of links and see if we have already fetched the links for each subreddit the user wants to load
    //If we don't have the links, call method to retrieve links (which adds to dictionary)
    
    for (int i=0; i<= [self.SelectedSubreddits count]-1; i++) {
        if([[self LinksDictionary] objectForKey:self.SelectedSubreddits[i]] == nil) {
            //The subreddit does not exist in our dictionary
            [self GetTopLinksOfSubreddit:self.SelectedSubreddits[i]];
        }
    }

    
}

- (IBAction)LoadPressed:(id)sender {
    
    [[[DatabaseModel sharedManager] ActiveThreads] removeAllObjects];
    
        RKLink *link;
    
    //For each selected subreddit, Create a tab for each top link
    //[self.SelectedSubreddits count]
    for (int i=0; i<[self.SelectedSubreddits count]; i++) {
        for (int x=1; x<4; x++) {
           
            //Access the array of links sitting in the dictionary for the given subreddit and assign the top URL
        link = self.LinksDictionary[self.SelectedSubreddits[i]][x];
        NSString *path = [link.URL absoluteString];
        
        //NSLog(path);
        //If the link isn't a comment thread, skip
        //Should be a way to check for self post in the api
        if ([path rangeOfString:@"/comments/"].location == NSNotFound) {
        }else{
            //Link is a reddit thread link
            //Add this Link to the Threads array to be loaded by the next view controller
            NSLog(path);
            
            //Check if link is nil
            if (!link) {
            }else{
                [[[DatabaseModel sharedManager] ActiveThreads] addObject:link];
            }
        }
            
            
    }
        
        
        
    
    }
    ThreadsViewController *threadsViewController = threadsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"threadsViewController"];
    
    [self.navigationController pushViewController:threadsViewController animated:YES];
    
    
}

//////////////Table View Methods //////////////////
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
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
                [self UpdateLinksOfSelections];
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









///////////event handlers fired upon notifications///////////
-(void)SignedInWasNotified: (NSNotification *) notification
{
    NSLog(@"Sign in was notified");
    lblStatus.text = @"Login succesful";
    if (NeedSubreddits) {
        [self GetSubscribedSubreddits];
    }
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
    
}
-(void)RetrievedLinksWasNotified: (NSNotification *) notification
{
    NSLog(@"Retrieved Links was notified");
    
}

@end
