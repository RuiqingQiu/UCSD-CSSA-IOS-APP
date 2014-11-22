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

+ (NSString*) getRkey: (NSString**)errorString
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
        if (error2 != nil)
            time = [[NSDate date] timeIntervalSince1970];
        else
            time = [[parsedDict valueForKey:@"timestamp" ] intValue];
    }
    
    return time ^ 1212496151;
}

+ (BOOL) signUpWithUsername:(NSString*)username password:(NSString*)password name:(NSString*)name department:(NSInteger)department position:(NSString*)position college:(NSInteger)college major:(NSString*)major motto:(NSString*)motto errorString:(NSString**)errorString
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
    NSInteger tkey = [self getTkey];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/register.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString* post = [NSString stringWithFormat:@"tkey=%ld&username=%@&passwd=%@&name=%@&department=%ld&position=%@&college=%ld&major=%@&motto=%@",(long)tkey,username,[self md5:password],name?name:@"",(long)department,position?position:@"",(long)college,major?major:@"",motto?motto:@""];
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
    if ([[parsedDict valueForKey:@"return"] intValue] != 0)
    {
        if (errorString != nil)
            *errorString = [parsedDict objectForKey:@"err"];
        return YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[parsedDict objectForKey:@"rkey"] forKey:@"rkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([parsedDict objectForKey:@"rkey"] != [self getRkey:nil])
        return YES;
    return NO;
}

@end
