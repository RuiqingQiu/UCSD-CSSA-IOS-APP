//
//  Badge.h
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Badge : NSObject
{
    
}

@property NSString *name;
@property BOOL isHidden;
@property double longtitude;
@property double latitude;
//@property NSString *description;
@property int badgeID;
@property UIImage *image;
-(Badge*)initWithID:(int) BadgeID;

@end
