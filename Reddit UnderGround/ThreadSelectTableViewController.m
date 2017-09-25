//
//  ThreadSelectTableViewController.m
//  Reddit UnderGround
//
//  Created by Rob on 9/21/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "ThreadSelectTableViewController.h"
#import "DatabaseModel.h"
#import "SubredditTableViewCell.h"
#import "WebViewController.h"

@interface ThreadSelectTableViewController ()

@end

@implementation ThreadSelectTableViewController

@synthesize tblThreads = _tblThreads;
-(UITableView *) tblReddits{
    if (!_tblThreads) {
        _tblThreads = [[UITableView alloc]init];
    }
    return _tblThreads;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tblThreads setDelegate:self];
    [self.tblThreads setDataSource:self];
    [self.tblThreads setAllowsSelection:YES];
    
     [self.tblThreads reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tblThreads reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

//////////////Table View Methods //////////////////
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
   
    
}
- (IBAction)LoadPressed:(id)sender {
     [self.tblThreads reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SubredditTableViewCell *cell = (SubredditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"subreddit"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"identifier"];
    }
    
    // NSLog(@"Subscribed Subreddits: %lu",(unsigned long)[self.SubscribedSubreddits count]);
    //  NSLog(subreddit.name);
    
    if ([[[DatabaseModel sharedManager] ActiveTabs] count] != 0) {
        
    
    
    WebViewController *webview;
    
    webview = [[DatabaseModel sharedManager] ActiveTabs][indexPath.row];
   
    cell.lblSubredditName.text = webview.URL;
    //Set image
    //cell.Image.image = subreddit
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{//within tbl search need to return different
    //return [[[DatabaseModel sharedManager] ActiveTabs] count];
    return 1;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
