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
    [[[DatabaseModel sharedManager] LoadedWebViews] removeAllObjects];
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
    
    
    RKLink *link;
//Loop through thread links and load each in a web view
    for (int i = 0; i< [[[DatabaseModel sharedManager] ActiveThreads] count]; i++) {
        
        link = [[DatabaseModel sharedManager] ActiveThreads] [i];
        
        UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(500,30,319, 383)];
        wv.delegate = self;
        [wv loadRequest:
         [NSURLRequest requestWithURL:
          link.URL]];
        
        [self.view addSubview: wv];
        wv.scalesPageToFit = YES;
        wv.hidden  = YES;
        
        // Round corners using CALayer property
        [[wv layer] setCornerRadius:10];
        [wv setClipsToBounds:YES];
        
        // Create colored border using CALayer property
        [[wv layer] setBorderColor:
         
         [[UIColor colorWithRed:159.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0] CGColor]];
        [[wv layer] setBorderWidth:1.75];
        
        [[[DatabaseModel sharedManager] LoadedWebViews] addObject:wv];
    }
    
    UIWebView *FirstThread = [[DatabaseModel sharedManager] LoadedWebViews][0];
    FirstThread.hidden = NO;
    
    FirstThread.hidden = NO;
    
    
    [UIView animateWithDuration:0.4 animations:^{
        FirstThread.frame = CGRectMake(1, 67, 319, 383);
    }];

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIWebView *wv;
    wv =[[DatabaseModel sharedManager] LoadedWebViews][indexPath.row];
    if (wv.frame.origin.x !=1) {
        
    
    
        //Hide all web views
        for (int i = 0; i < [[[DatabaseModel sharedManager] LoadedWebViews] count]; i++) {
            wv =[[DatabaseModel sharedManager] LoadedWebViews][i];
            if (wv.frame.origin.x == 1) {
           
            
                [UIView animateWithDuration:0.3 animations:^{
                    wv.frame = CGRectMake(-500,30,319, 383);
                    //wv.hidden = YES;
                }
                            completion:^(BOOL finished){
                                if (finished) {
                                        wv.frame = CGRectMake(500,30,319, 383);
                                    }
                
                }];
            
                }
            }
        
        //Unhide selected web view
        wv =[[DatabaseModel sharedManager] LoadedWebViews][indexPath.row];
        wv.hidden = NO;
    
    
        [UIView animateWithDuration:0.4 animations:^{
        wv.frame = CGRectMake(1, 67, 319, 383);
        }];
        }
        
        
    }
   // CGRectMake(1,67,319,383)];
    
    
    


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{//within tbl search need to return different
    return [[[DatabaseModel sharedManager] ActiveThreads] count];
    //return 1;
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
