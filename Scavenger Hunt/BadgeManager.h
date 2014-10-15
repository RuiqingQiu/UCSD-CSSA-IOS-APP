//
//  BadgeManager.h
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

//Test

#import <Foundation/Foundation.h>

@interface BadgeManager : NSObject
{
}
+(BadgeManager*)sharedBadgeManager;
-(NSArray*)getBadgeInventory;
-(void)setBadgeInventory: (NSArray*)badgeList;
@property NSMutableArray* badgeList;

@end
