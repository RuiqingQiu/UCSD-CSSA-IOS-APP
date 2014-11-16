//
//  ProfileViewController.m
//  Scavenger Hunt
//
//  Created by ennuma on 14-10-15.
//  Copyright (c) 2014年 Ruiqing Qiu. All rights reserved.
//

#import "ProfileViewController.h"
#include <CommonCrypto/CommonDigest.h>
@implementation ProfileViewController
NSArray* arr;
bool editOrNot = YES;
-(void)viewWillAppear:(BOOL)animated {
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rkey"] == nil)
        self.view = loginView;      //show loginview
    else
        self.view = profileView;
    
    NSString* rkey = [[NSUserDefaults standardUserDefaults] stringForKey:@"rkey"];
    NSLog(@"rkey %@", rkey);
    [self loadDataWithRKey:rkey];
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
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}



-(void)keyboardHide:(UITapGestureRecognizer*)tap{

    [login_pass resignFirstResponder];
    [loging_user resignFirstResponder];
    [nameField resignFirstResponder];
    [positionField resignFirstResponder];
    //[collegeField resignFirstResponder];
    [majorField resignFirstResponder];
    [mottoField resignFirstResponder];
    

}


-(void)loadDataWithRKey:(NSString*) rkey
{
    if(rkey == nil){
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/getProfile.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
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
        
        if ([[[connection currentRequest].URL absoluteString]isEqualToString:@"http://b.ucsdcssa.org/login.php"]) {
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
            positionField.backgroundColor = [UIColor clearColor];
            //nameField.background = [UIColor clearColor];
            collegeField.backgroundColor = [UIColor clearColor];
            majorField.backgroundColor = [UIColor clearColor];
            mottoField.backgroundColor = [UIColor clearColor];
            if(valueAsString == [NSNull null]){
                continue;
            }
            if ([keyAsString isEqualToString:@"name"]) {
                [nameField setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"position"]) {
                [positionField setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"college"]) {
                NSString* colle = [arr objectAtIndex:[valueAsString intValue]];
                [collegeField setText:colle];
            }
            if ([keyAsString isEqualToString:@"major"]) {
                [majorField setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"motto"]) {
                [mottoField setText:valueAsString];

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



- (IBAction)editProfile:(id)sender
{
    
    if(editOrNot == YES)
    {
        nameField.enabled = YES;
        majorField.enabled = YES;
        mottoField.enabled = YES;
        [editButton setTitle:@"Save" forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nameField becomeFirstResponder];
        editOrNot = NO;
    }
    else
    {
        collegeField.enabled = NO;
        majorField.enabled = NO;
        mottoField.enabled =NO;
        editOrNot = YES;
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
     
}

- (IBAction)login:(id)sender {
    NSString * timestampJson = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.convert-unix-time.com/api?timestamp=now"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * timestampDictionary = [NSJSONSerialization JSONObjectWithData:[timestampJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    int i_time = [[timestampDictionary valueForKey:@"timestamp"] intValue];
    //NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    //int i_time = [timestamp intValue];
    int tkey = i_time^1212496151;
    NSString* s_tkey = [NSString stringWithFormat:@"%i",tkey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/login.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"tkey=%@&username=%@&passwd=%@", s_tkey, loging_user.text,[self md5:login_pass.text]];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection setAccessibilityHint:@"login"];
    //[request setAccessibilityHint:@"login"];
    //NSLog(@"%@",timestamp);
}
- (IBAction)dismissLoginName:(id)sender
{
[sender resignFirstResponder];
}

- (IBAction)dismissNmae:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)dismissPassword:(id)sender
{
[sender resignFirstResponder];}

- (IBAction)dismissPosition:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)signOut:(id)sender {
    NSLog(@"signout");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    self.view = loginView;
    
    
    
    
    
}

- (IBAction)dismissMotto:(id)sender {
      //[sender resignFirstResponder];
}


- (IBAction)dismissMajor:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)didBeginEditing:(id)sender {
    
    [self animateTextField: self up: YES];
}

- (IBAction)didEndEditing:(id)sender {
    [self animateTextField: self up: NO];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

@end
