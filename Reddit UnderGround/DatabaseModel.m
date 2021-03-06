//
//  DatabaseModel.m
//  Picl
//
//  Created by Rob on 4/1/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import "DatabaseModel.h"
#import "RedditUnderGroundAppDelegate.h"
#import "RedditUnderGroundViewController.h"
#import "ThreadSelectTableViewController.h"

@interface DatabaseModel()

@end

@implementation DatabaseModel


-(NSMutableArray *) SelectedSubreddits{
    if (!_SelectedSubreddits) {
        _SelectedSubreddits = [[NSMutableArray alloc]init];
    }
    return _SelectedSubreddits;
}
-(NSMutableArray *) ActiveTabs{
    if (!_ActiveTabs) {
        _ActiveTabs = [[NSMutableArray alloc]init];
    }
    return _ActiveTabs;
}
-(NSMutableArray *) LoadedComments{
    if (!_LoadedComments) {
        _LoadedComments = [[NSMutableArray alloc]init];
    }
    return _LoadedComments;
}
-(NSMutableArray *) ActiveThreads{
    if (!_ActiveThreads) {
        _ActiveThreads = [[NSMutableArray alloc]init];
    }
    return _ActiveThreads;
}
-(NSMutableArray *) LoadedWebViews{
    if (!_LoadedWebViews) {
        _LoadedWebViews = [[NSMutableArray alloc]init];
    }
    return _LoadedWebViews;
}


#pragma mark Singleton Methods

+ (id)sharedManager {
    static DatabaseModel *sharedDatabaseModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatabaseModel = [[self alloc] init];
    });
    return sharedDatabaseModel;
}

- (id)init {
    if (self = [super init]) {
        DeviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void) setRefresh:(bool)Refresh {
    _Refresh = Refresh;
}
-(void) setCustomUser:(NSString *)CustomUser {
    _CustomUser = CustomUser;
}
-(NSString *) getCustomUser {
   return  _CustomUser;
}
-(BOOL) getRefresh {
    return  _Refresh;
}

-(void) setNumberOfSubreddits:(int)NumberOfSubreddits {
    _NumberOfSubreddits = NumberOfSubreddits;
}
-(void) setNumberOfThreads:(int)NumberOfThreads{
    _NumberOfThreads = NumberOfThreads;
}

-(NSString *) GetCurrentDateAndTime {
    // Get current date time
    
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH-mm-ss"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    NSLog(@"%@", dateInStringFormated);

    return dateInStringFormated;
}


@end
