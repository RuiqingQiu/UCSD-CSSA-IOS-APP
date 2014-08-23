//
//  BadgeManager.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "BadgeManager.h"
#import "Badge.h"
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
@end
