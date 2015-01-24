//
//  TalkToServer.h
//  CSSAMon
//
//  Created by zhangjinzhe on 11/19/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkToServer : NSObject

+ (BOOL) signUpWithUsername:(NSString*)username password:(NSString*)password name:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto Pavatar_large:(UIImage**)avatar_large PerrorString:(NSString**)errorString;
+ (BOOL) signInWithUsername:(NSString*)username password:(NSString*)password Pname:(NSString**)name Pavatar_large:(UIImage**)avatar_large Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString;
+ (BOOL) isOfficerWithPerrorString:(NSString**)errorString;
+ (BOOL) updateProfileWithName:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto PerrorString:(NSString**)errorString;
+ (BOOL) getProfileWithId:(NSInteger)id_ Pname:(NSString**)name Pavatar_large:(UIImage**)avatar_large PisOfficer:(BOOL*)isOfficer Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString;
+ (BOOL) updateLocationWithLatitude:(double)latitude longitude:(double)longitude PerrorString:(NSString**)errorString;

+ (NSArray*) getLocationWithPerrorString:(NSString**)errorString;
// use
// UIImage * foo = [[RETURNED_ARRAY objectAtIndex:i] objectForKey:@"avatar_small"]
// to get small images

+ (BOOL) isSharingLocationWithPerrorString:(NSString**)errorString;
//You have to check if errorString is nil. If is not nil, returned value invalid.

+ (BOOL) deleteLocationWithPerrorString:(NSString**)errorString;

+ (BOOL) sendChatWithReceiverId:(NSInteger)to msg:(NSInteger)msg PerrorString:(NSString**)errorString;
+ (NSArray*) getChatWithPerrorString:(NSString**)errorString;
+ (BOOL) readChatWithChatId:(NSInteger)chat_id PerrorString:(NSString**)errorString;
@end
