//
//  ProfileViewController.m
//  Scavenger Hunt
//
//  Created by ennuma on 14-10-15.
//  Copyright (c) 2014年 Ruiqing Qiu. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController
NSArray* arr;
-(void)viewWillAppear:(BOOL)animated {
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:@"rkey"];
    //test
    //obj = nil;
    //
    if (obj == nil) {
        //show loginview
        self.view = loginView;
    }else{
        self.view = profileView;
        
    }
    NSString* str = (NSString*)obj;
    NSLog(@"key %@", str);
    [self loadDataWithRKey:str];
    arr = [[NSArray alloc]initWithObjects:@"",@"ERC", @"Marshall", @"Muir", @"Revelle", @"Warren", @"Sixth",nil];
    //self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
   // self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{

    [login_pass resignFirstResponder];
    [loging_user resignFirstResponder];

    
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


-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"%@", fileURL);
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    NSLog(@"result: %@", result);
    
    return result;
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
        NSLog(@"%@",[[connection currentRequest].URL absoluteString]);
        
        if ([[[connection currentRequest].URL absoluteString]isEqualToString:@"http://c.zinsser.me/login.php"]) {
            NSLog(@"key: %@", keyAsString);
            NSLog(@"value: %@", valueAsString);
            //do login
            if ([keyAsString isEqualToString:@"rkey"]) {
                 [[NSUserDefaults standardUserDefaults] setObject:valueAsString forKey:keyAsString];
                [self viewWillAppear:NO];
            }
            
            if ([keyAsString isEqualToString:@"return"]) {
                if ([valueAsString intValue] != 0) {
                    //err occur login fail
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                                    message:@"Login failed. Check your pswd and username!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
        }else{
            NSLog(@"%@", keyAsString);
            NSLog(@"%@", valueAsString);
            if(valueAsString == [NSNull null]){
                continue;
            }
            if ([keyAsString isEqualToString:@"name"]) {
                [Name setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"position"]) {
                [JobTitle setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"college"]) {
                NSString* colle = [arr objectAtIndex:[valueAsString intValue]];
                [College setText:colle];
            }
            if ([keyAsString isEqualToString:@"major"]) {
                [Major setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"motto"]) {
                [Motto setText:valueAsString];

            }
            if([keyAsString isEqualToString:@"avatar_large"]){
                [avatar setImage:[self getImageFromURL:valueAsString]];
            }
            
        }
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}


- (IBAction)login:(id)sender {
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    int i_time = [timestamp intValue];
    int tkey = i_time^1212496151;
    NSString* s_tkey = [NSString stringWithFormat:@"%i",tkey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/login.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"tkey=%@&username=%@&passwd=%@", s_tkey, loging_user.text,login_pass.text];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection setAccessibilityHint:@"login"];
    //[request setAccessibilityHint:@"login"];
    //NSLog(@"%@",timestamp);
}
- (IBAction)dismissLoginName:(id)sender
{
[sender resignFirstResponder];}
- (IBAction)dismissPassword:(id)sender
{
[sender resignFirstResponder];}

@end
