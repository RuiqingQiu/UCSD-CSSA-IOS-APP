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
const int BadgeNumber = 26;
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
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *data = [def objectForKey:BADGE_KEY];
    NSArray *retrivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray* idArr = [[NSArray alloc] initWithArray:retrivedArray];
    NSMutableArray* ret = [[NSMutableArray alloc]init];
    for (NSNumber *badgeID in idArr) {
        [ret addObject:[[Badge alloc] initWithID:[badgeID intValue]]];
    }
    return ret;
}

-(void)setBadgeInventory:(NSArray *)badgeList
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (Badge *badge in badgeList) {
        [arr addObject:[NSNumber numberWithInt:badge.badgeID]];
    }
    [def setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:BADGE_KEY];
    [def synchronize];
}
@end
