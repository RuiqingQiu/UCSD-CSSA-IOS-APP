//
//  LoginViewController.m
//  Scavenger Hunt
//
//  Created by TK on 10/12/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation RegisterViewController
@synthesize responseData = _responseData;

- (IBAction)save:(id)sender;
{
    NSString *loginNameString = loginNameFiled.text;
    NSUserDefaults *defaults0 = [NSUserDefaults standardUserDefaults];
    [defaults0 setObject:loginNameString forKey:@"loginNameString"];
    [defaults0 synchronize];
    
    
    NSString *passwordString = passwordField.text;
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 setObject:passwordString forKey:@"passwordString"];
    [defaults1 synchronize];
    
    NSString *nameString = nameField.text;
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    [defaults2 setObject:nameString forKey:@"nameString"];
    [defaults2 synchronize];
    
    NSLog(@"%@", nameString);
    
    NSString *majorString = majorField.text;
    NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
    [defaults3 setObject:majorString forKey:@"majorString"];
    [defaults3 synchronize];
    

    NSString *collegeString = button.currentTitle;
    NSString *choice = @"请选择";
    NSString *erc = @"ERC";
    NSString *marshall = @"Marshall";
    NSString *muir = @"Muir";
    NSString *revelle = @"Revelle";
    NSString *warren = @"Warren";
    NSString *sixth = @"Sixth";
    int collegeNumber;
    if([collegeString isEqualToString:choice])
    {
        NSLog(@"!!");
        collegeNumber = 0;
    }
    else if ([collegeString isEqualToString:erc])
    {
        collegeNumber = 1;
    }
    else if ([collegeString isEqualToString:marshall])
    {
        collegeNumber = 2;
    }
    else if ([collegeString isEqualToString:muir])
    {
        collegeNumber = 3;
    }
    else if ([collegeString isEqualToString:revelle])
    {
        collegeNumber = 4;
    }
    else if ([collegeString isEqualToString:warren])
    {
        collegeNumber = 5;
    }
    else if ([collegeString isEqualToString:sixth])
    {
        collegeNumber = 6;
    }
    NSNumber *college = [NSNumber numberWithInteger: collegeNumber];
    //NSLog(@"%@",collegeString);
    NSString *mottoString = mottoField.text;
    NSUserDefaults *defaults5 = [NSUserDefaults standardUserDefaults];
    [defaults5 setObject:mottoString forKey:@"mottoString"];
    [defaults5 synchronize];
    
    double time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                loginNameString,@"username",
                                passwordString,@"passwd",
                                nameString,@"name",
                                majorString,@"major",
                                college,@"college",
                                mottoString,@"motto",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/register.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    //NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody: data];
    NSString* str = [NSString stringWithFormat:@"username=%@&passwd=%@&name=%@&college=%@&major=%@&motto=%@", loginNameString, passwordString,nameString,college,majorString,mottoString];
    NSLog(@"%@",str);
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    //if (connection) {
    //    receive = [[NSMutableData data] retain];
    //}
   

}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [loginNameFiled resignFirstResponder];
    [passwordField resignFirstResponder];
    [nameField resignFirstResponder];
    [majorField resignFirstResponder];
    [mottoField resignFirstResponder];

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
        if([keyAsString isEqualToString:@"rkey"]){
            [[NSUserDefaults standardUserDefaults] setObject:valueAsString forKey:keyAsString];
        }
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        
        
        if ([keyAsString isEqualToString:@"return"]) {
            if ([valueAsString intValue] == 0) {
                //success
                [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)dismissLoginName:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)dismissPassword:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)dismissName:(id)sender
{
    [sender resignFirstResponder];
}



- (IBAction)dismissMajor:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)dismissMotto:(id)sender{
    [sender resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Data
    dataArray = [[NSArray alloc]initWithObjects:@"ERC", @"Marshall", @"Muir", @"Revelle", @"Warren", @"Sixth",nil];
    
    picker.delegate = self;
    [picker setHidden:YES];
    [bar setHidden:YES];
    
    self.responseData = [NSMutableData data];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArray count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [button setTitle:[dataArray objectAtIndex:row] forState:UIControlStateNormal];
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}

-(void)hideAndShow
{
    if([picker isHidden])
    {
        [picker setHidden:NO];
        [bar setHidden:NO];
        
    }
    else
    {
        [picker setHidden:YES];
        [bar setHidden:YES];
        
        
    }
}

-(IBAction)btnPressed:(id)sender
{
    [self hideAndShow];
    
}

- (IBAction)doneButton:(id)sender
{
    [self hideAndShow];
    
    
}


@end


