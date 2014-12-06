//
//  TalkToServer.h
//  CSSAMon
//
//  Created by zhangjinzhe on 11/19/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkToServer : NSObject

+ (BOOL) signUpWithUsername:(NSString*)username password:(NSString*)password name:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto PerrorString:(NSString**)errorString;
+ (BOOL) signInWithUsername:(NSString*)username password:(NSString*)password Pname:(NSString**)name Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString;
+ (BOOL) isOfficerWithPerrorString:(NSString**)errorString;
+ (BOOL) updateProfileWithName:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto PerrorString:(NSString**)errorString;
@end
