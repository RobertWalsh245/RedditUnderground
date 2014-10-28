//
//  DatabaseModel.h
//  Picl
//
//  Created by Rob on 4/1/14.
//  Copyright (c) 2014 RobMWalsh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DatabaseModel : NSObject {
    NSString *DeviceID;
}

@property (nonatomic, retain) NSString *DeviceID;
@property (nonatomic, retain) NSMutableArray *ActiveTabs;
@property (nonatomic, retain) NSMutableArray *ActiveThreads;
@property (nonatomic, retain) NSMutableArray *LoadedWebViews;

@property (nonatomic, retain) NSMutableArray *LoadedComments;

-(NSString *) GetCurrentDateAndTime;

+ (id)sharedManager;



@end
