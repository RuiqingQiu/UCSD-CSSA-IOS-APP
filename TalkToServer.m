//
//  TalkToServer.m
//  CSSAMon
//
//  Created by zhangjinzhe on 11/19/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "TalkToServer.h"
#include <CommonCrypto/CommonDigest.h>

@implementation TalkToServer

+ (NSString*) md5:(NSString*) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

+ (NSString*) getRkeyWithPerrorString: (NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rkey"] == nil)
    {
        if (errorString != nil)
            *errorString = @"Did not login";
        return nil;
    }
    NSString* rkey = [[NSUserDefaults standardUserDefaults] stringForKey:@"rkey"];
    //Use regex to verify if rkey is a 32-hex md5 hash
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[a-f0-9]{32}$"
                                  options:0 error:nil];
    NSInteger match = [regex numberOfMatchesInString:rkey options:0 range:NSMakeRange(0, [rkey length])];
    if (match == 0)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"rkey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (errorString != nil)
            *errorString = @"Invalid rkey";
        return nil;
    }
    return rkey;
}

+ (NSInteger) getTkey
{
    int time = 0;
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.convert-unix-time.com/api?timestamp=now"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
        time = [[NSDate date] timeIntervalSince1970];
    else
    {
        NSError* error2 = nil;
        NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error2];
        if (error2 != nil || [[parsedDict objectForKey:@"timestamp"] isEqual:[NSNull null]])
            time = [[NSDate date] timeIntervalSince1970];
        else
            time = [[parsedDict valueForKey:@"timestamp" ] intValue];
    }
    
    return time ^ 1212496151;
}

+ (BOOL) signUpWithUsername:(NSString*)username password:(NSString*)password name:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto Pavatar_large:(UIImage**)avatar_large PerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    if (username == nil || [username length] == 0 || password == nil || [password length] == 0)
    {
        if (errorString != nil)
            *errorString = @"Username or password is missing";
        return YES;
    }
    if (department<0 || department>8)
    {
        if (errorString != nil)
            *errorString = @"Department invalid";
        return YES;
    }
    if (college<0 || college>6)
    {
        if (errorString != nil)
            *errorString = @"College invalid";
        return YES;
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/register.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* post = [NSString stringWithFormat:@"tkey=%ld&username=%@&passwd=%@&name=%@&department=%ld&position=%@&college=%ld&major=%@&motto=%@",(long)[self getTkey],username,[self md5:password],name?name:@"",(long)department,position?position:@"",(long)college,major?major:@"",motto?motto:@""];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[parsedDict objectForKey:@"rkey"] forKey:@"rkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([parsedDict objectForKey:@"rkey"] != [self getRkeyWithPerrorString:nil])
    {
        if (errorString != nil)
            *errorString = @"Can't set rkey";
        return YES;
    }
    if (avatar_large != nil)
    {
        NSData * tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[parsedDict objectForKey:@"avatar_large"]]];
        *avatar_large = [UIImage imageWithData:tmpData];
    }
    return NO;
}

+ (BOOL) signInWithUsername:(NSString*)username password:(NSString*)password Pname:(NSString**)name Pavatar_large:(UIImage**)avatar_large Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    if (username == nil || [username length] == 0 || password == nil || [password length] == 0)
    {
        if (errorString != nil)
            *errorString = @"Username or password is missing";
        return YES;
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/login.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* post = [NSString stringWithFormat:@"tkey=%ld&username=%@&passwd=%@",(long)[self getTkey],username,[self md5:password]];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[parsedDict objectForKey:@"rkey"] forKey:@"rkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([parsedDict objectForKey:@"rkey"] != [self getRkeyWithPerrorString:nil])
    {
        if (errorString != nil)
            *errorString = @"Can't set rkey";
        return YES;
    }
    if (name != nil) *name = [parsedDict objectForKey:@"name"];
    if (avatar_large != nil)
    {
        NSData * tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[parsedDict objectForKey:@"avatar_large"]]];
        *avatar_large = [UIImage imageWithData:tmpData];
    }
    if (department != nil && ![[parsedDict objectForKey:@"department"] isEqual:[NSNull null]])
        *department = [[parsedDict valueForKey:@"department"] intValue];
    else
        *department = 0;
    if (position != nil) *position = [parsedDict objectForKey:@"position"];
    if (college != nil && ![[parsedDict objectForKey:@"college"] isEqual:[NSNull null]])
        *college = [[parsedDict valueForKey:@"college"] intValue];
    else
        *college = 0;
    if (major != nil) *major = [parsedDict objectForKey:@"major"];
    if (motto != nil) *motto = [parsedDict objectForKey:@"motto"];
    return NO;
}

+ (BOOL) isOfficerWithPerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/isOfficer.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return NO;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@",rkey];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return NO;
    }
    if ([[parsedDict objectForKey:@"isOfficer"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    return [[parsedDict valueForKey:@"isOfficer"] boolValue];
}

+ (BOOL) updateProfileWithName:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto PerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    if (department<0 || department>8)
    {
        if (errorString != nil)
            *errorString = @"Department invalid";
        return YES;
    }
    if (college<0 || college>6)
    {
        if (errorString != nil)
            *errorString = @"College invalid";
        return YES;
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/updateProfile.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return YES;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@&name=%@&department=%ld&position=%@&college=%ld&major=%@&motto=%@",rkey,name?name:@"",(long)department,position?position:@"",(long)college,major?major:@"",motto?motto:@""];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    return NO;
}

+ (BOOL) getProfileWithId:(NSInteger)id_ Pname:(NSString**)name Pavatar_large:(UIImage**)avatar_large PisOfficer:(BOOL*)isOfficer Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString
//using id_ because id is a reserved word
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/getProfile.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return YES;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@&profile_id=%ld",rkey,(long)id_];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    if (name != nil) *name = [parsedDict objectForKey:@"name"];
    if (avatar_large != nil)
    {
        NSData * tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[parsedDict objectForKey:@"avatar_large"]]];
        *avatar_large = [UIImage imageWithData:tmpData];
    }
    if (isOfficer != nil && ![[parsedDict objectForKey:@"isOfficer"] isEqual:[NSNull null]])
        *isOfficer = [[parsedDict valueForKey:@"isOfficer"] boolValue];
    else
        *isOfficer = NO;
    if (department != nil && ![[parsedDict objectForKey:@"department"] isEqual:[NSNull null]])
        *department = [[parsedDict valueForKey:@"department"] intValue];
    else
        *department = 0;
    if (position != nil) *position = [parsedDict objectForKey:@"position"];
    if (college != nil && ![[parsedDict objectForKey:@"college"] isEqual:[NSNull null]])
        *college = [[parsedDict valueForKey:@"college"] intValue];
    else
        *college = 0;
    if (major != nil) *major = [parsedDict objectForKey:@"major"];
    if (motto != nil) *motto = [parsedDict objectForKey:@"motto"];
    return NO;
}

+ (BOOL) updateLocationWithLatitude:(double)latitude longitude:(double)longitude PerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/updateLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return YES;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@&latitude=%lf&longitude=%lf",rkey,latitude,longitude];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    return NO;
}

+ (NSArray*) getLocationWithPerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/getLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return nil;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@",rkey];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return nil;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return nil;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return nil;
    }
    if ([[parsedDict objectForKey:@"result"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return nil;
    }
    NSArray* tmpArray = [parsedDict objectForKey:@"result"];
    /* Initially designed to load all images
    for (int i = 0; i < tmpArray.count; i++)
    {
        NSData * tmpData = [NSData dataWithContentsOfURL:[[tmpArray objectAtIndex:i] objectForKey:@"avatar_small"]];
        [[tmpArray objectAtIndex:i] setObject:[UIImage imageWithData:tmpData] forKey:@"avatar_small"];
    } */
    return tmpArray;
}

+ (BOOL) isSharingLocationWithPerrorString:(NSString**)errorString
//You have to check if errorString is nil
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/isSharingLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return NO;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@",rkey];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return NO;
    }
    if ([[parsedDict objectForKey:@"isSharingLocation"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return NO;
    }
    return [[parsedDict valueForKey:@"isSharingLocation"] boolValue];
}

+ (BOOL) deleteLocationWithPerrorString:(NSString**)errorString
{
    if (errorString != nil)
        *errorString = nil;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/deleteLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* getRkeyError = nil;
    NSString* rkey = [self getRkeyWithPerrorString:&getRkeyError];
    if (getRkeyError != nil)
    {
        if (errorString != nil)
            *errorString = getRkeyError;
        return YES;
    }
    NSString* post = [NSString stringWithFormat:@"rkey=%@",rkey];
    [request setHTTPBody:[post dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil)
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    NSDictionary* parsedDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[parsedDict objectForKey:@"return"] isEqual:[NSNull null]])
    {
        if (errorString != nil)
            *errorString = @"Failed to connect to server";
        return YES;
    }
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    return NO;
}

@end
