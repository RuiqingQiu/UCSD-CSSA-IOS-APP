//
//  LoginViewController.m
//  Scavenger Hunt
//
//  Created by TK on 10/12/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import "RegisterViewController.h"
#include <CommonCrypto/CommonDigest.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RegisterViewController ()
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation RegisterViewController
@synthesize responseData = _responseData;
FBLoginView *loginView;

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
    
    
    
    NSString *departmentString = buttonDepartment.currentTitle;
    //NSString *choice = @"请选择";
    NSString *pm = @"PM";
    NSString *xs= @"学术";
    NSString *xc = @"宣传";
    NSString *wt = @"文体";
    NSString *js= @"技术";
    NSString *wl = @"外联";
    NSString *ad = @"Advisor&前辈";
    NSString *qt = @"其他officer";
    
    int departmentNumber;
    if([departmentString isEqualToString:choice])
    {
        departmentNumber = 0;
    }
    else if ([departmentString isEqualToString:pm])
    {
        departmentNumber= 1;
    }
    else if ([departmentString isEqualToString:xs])
    {
        departmentNumber = 2;
    }
    else if ([departmentString isEqualToString:xc])
    {
        departmentNumber= 3;
    }
    else if ([departmentString isEqualToString:wt])
    {
        departmentNumber = 4;
    }
    else if ([departmentString isEqualToString:js])
    {
        departmentNumber= 5;
    }
    else if ([departmentString isEqualToString:wl])
    {
        departmentNumber = 6;
    }
    else if ([departmentString isEqualToString:ad])
    {
        departmentNumber= 7;
    }
    else if ([departmentString isEqualToString:qt])
    {
        departmentNumber = 8;
    }
    NSNumber *department = [NSNumber numberWithInteger: departmentNumber];
    
  
    
    NSString *mottoString = mottoField.text;
    NSUserDefaults *defaults5 = [NSUserDefaults standardUserDefaults];
    [defaults5 setObject:mottoString forKey:@"mottoString"];
    [defaults5 synchronize];
    
    NSString * timestampJson = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.convert-unix-time.com/api?timestamp=now"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * timestampDictionary = [NSJSONSerialization JSONObjectWithData:[timestampJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    int i_time = [[timestampDictionary valueForKey:@"timestamp"] intValue];
    
    NSString *tkeyString = [NSString stringWithFormat:@"%d",((int)i_time^1212496151)];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                tkeyString,@"tkey",
                                loginNameString,@"username",
                                passwordString,@"passwd",
                                nameString,@"name",
                                department,@"department",
                                majorString,@"major",
                                college,@"college",
                                mottoString,@"motto",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/register.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    //NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];

    NSString* str = [NSString stringWithFormat:@"tkey=%@&username=%@&passwd=%@&name=%@&department=%@&college=%@&major=%@&motto=%@", tkeyString,loginNameString, [self md5:passwordString],nameString,department,college,majorString,mottoString];
    NSLog(@"!!!!!!!!!!!!!@##!#!!!!!!!!!!");
    NSLog(@"%@",str);
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

   

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
    
    departmentArray = [[NSArray alloc]initWithObjects:@"非officer", @"PM", @"学术", @"宣传", @"文体", @"技术",@"外联", @"Advisor&前辈", @"其他officer",nil];
    departmentShow = FALSE;
    collegeShow = FALSE;
    
    picker.delegate = self;
    departmentPicker.delegate = self;
    [departmentPicker setHidden:YES];
    [picker setHidden:YES];
    [bar setHidden:YES];
    
    self.responseData = [NSMutableData data];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //Facebook login, tested and it works.
    loginView = [[FBLoginView alloc] init];
    [self.view addSubview:loginView];
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)),  self.view.center.y + (loginView.frame.size.height*3.5));
    [self.view addSubview:loginView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    if([pickerView isEqual: picker]){
        // return the appropriate number of components, for instance
        return 1;
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        return 1;
    }
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if([pickerView isEqual: picker]){
        // return the appropriate number of components, for instance
        return [dataArray count];
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        return [departmentArray count];
    }
    
    return nil;

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    //[button setTitle:[dataArray objectAtIndex:row] forState:UIControlStateNormal];
    
    
    if([pickerView isEqual: picker]){
        // return the appropriate number of components, for instance
        [button setTitle:[dataArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        [buttonDepartment setTitle:[departmentArray objectAtIndex:row] forState:UIControlStateNormal];
    }

}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if([pickerView isEqual: picker]){
        // return the appropriate number of components, for instance
        return [dataArray objectAtIndex:row];
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        return [departmentArray objectAtIndex:row];
    }
    
    return nil;

}

-(void)hideAndShow
{
    [bar setHidden:NO];
    if(collegeShow == true && departmentShow == false)
    {
        [picker setHidden:NO];
        [departmentPicker setHidden:YES];
        loginView.hidden = YES;
        //[bar setHidden:NO];
        
    }
    
    if(departmentShow == true && collegeShow == false)
    {
        [departmentPicker setHidden:NO];
        [picker setHidden:YES];
        loginView.hidden = YES;
        //[bar setHidden:NO];
        
    }
    
    if(departmentShow == false && collegeShow == false)
    {
        loginView.hidden = FALSE;
        //[bar setHidden:NO];
        
    }

       
}

-(IBAction)btnPressed:(id)sender
{
    if(collegeShow == false)
    {
        collegeShow = true;
        departmentShow = false;
        [self hideAndShow];
    }
    
}

- (IBAction)doneButton:(id)sender
{
    [picker setHidden:YES];
    [departmentPicker setHidden:YES];
    [bar setHidden:YES];
    collegeShow = false;
    departmentShow = false;
    loginView.hidden = FALSE;
    
    
}

- (IBAction)beginEditing:(id)sender {
    [self animateTextField: self up: YES];
}

- (IBAction)endEditing:(id)sender {
    [self animateTextField: self up: NO];
}


- (IBAction)departmentPressed:(id)sender {
    if(departmentShow == false)
    {
        departmentShow = true;
        collegeShow = false;
        [self hideAndShow];
    }
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


@end


