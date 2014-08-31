//
//  BadgeManager.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "BadgeManager.h"
#import "Badge.h"
#define BADGE_KEY @"cssa_scavenger_hunt_badge"
const int BadgeNumber = 5;
static BadgeManager *sharedManager;

@implementation BadgeManager
{
}
-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _badgeList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < BadgeNumber; i++) {
        [_badgeList addObject:[[Badge alloc] initWithID:i + 2]];
    }
    return self;
}

+(BadgeManager*)sharedBadgeManager
{
    if (!sharedManager) {
        sharedManager = [[self alloc]init];
    }
    return sharedManager;
}

-(NSArray*)getBadgeInventory
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* ret = [defaults objectForKey:BADGE_KEY];
    return ret;
}

-(void)setBadgeInventory:(NSArray *)badgeList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:badgeList forKey:BADGE_KEY];
}
@end
