//
//  ProfileViewController.m
//  Scavenger Hunt
//
//  Created by ennuma on 14-10-15.
//  Copyright (c) 2014年 Ruiqing Qiu. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController
-(void)viewWillAppear:(BOOL)animated {
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:@"rkey"];
    NSString* str = (NSString*)obj;
    NSLog(@"key %@", str);
    [self loadDataWithRKey:str];
}

-(void)loadDataWithRKey:(NSString*) rkey
{
    if(rkey == nil){
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/getProfile.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"rkey=%@&profile_id=0", rkey];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
 
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        if ([keyAsString isEqualToString:@"name"]) {
            [Name setText:valueAsString];
        }
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}
@end
