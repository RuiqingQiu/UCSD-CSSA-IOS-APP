//
//  Badge.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "Badge.h"

@implementation Badge
{

}

-(Badge*)initWithID:(int) BadgeID
{
    self = [super init];
    if(!self){
        return nil;
    }
    self.badgeID = BadgeID;
    switch (BadgeID) {
        case 2:
            self.name = @"0";
            self.isHidden = NO;
            self.longtitude = 0.0;
            self.latitude = 0.0;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"Big_red_chair.png"];
            break;
        case 3:
            self.name = @"1";
            self.isHidden = NO;
            self.longtitude = -117.239719;
            self.latitude = 32.878560;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"Xueba_help_me_AS_Notes.png"];
            break;
        case 4:
            self.name = @"2";
            self.isHidden = NO;
            self.longtitude = 0.0;
            self.latitude = 0.0;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"Sun_god_hug.png"];
            break;
        case 5:
            self.name = @"3";
            self.isHidden = NO;
            self.longtitude = 0.0;
            self.latitude = 0.0;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"Before_you_die.png"];
            break;
        case 6:
            self.name = @"4";
            self.isHidden = NO;
            self.longtitude = 0.0;
            self.latitude = 0.0;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"UC_Sea_ovt.png"];
            break;
        case 18:
            self.name = @"18";
            self.isHidden = NO;
            self.latitude = 32.881957;
            self.longtitude = -117.234124;
            self.description = @" ";
            self.image = [UIImage imageNamed:@"UC_Sea_ovt.png"];
            break;
        default:
            break;
    }
    return self;
}
@end