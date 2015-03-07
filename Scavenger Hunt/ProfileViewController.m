//
//  ProfileViewController.m
//  Scavenger Hunt
//
//  Created by ennuma on 14-10-15.
//  Copyright (c) 2014年 Ruiqing Qiu. All rights reserved.
//

#import "ProfileViewController.h"
#import "TalkToServer.h"
#include <CommonCrypto/CommonDigest.h>
#import "ChatHistoryTableViewController.h"

@implementation ProfileViewController
NSString* loginName;
NSString* password;
NSString* name;
NSInteger departmentInt;
NSInteger collegeInt;
NSString* major;
NSString* motto;
NSArray* arr;
NSArray* departmentArray;
NSArray* dataArray;
UIButton *history;

bool editOrNot = YES;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    nameField.enabled = NO;
    majorField.enabled = NO;
    mottoField.enabled = NO;
    departmentButton.enabled = NO;
    collegeButton.enabled = NO;
    editOrNot = YES;
    [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    // Initialize Data
    dataArray = [[NSArray alloc]initWithObjects:@"ERC", @"Marshall", @"Muir", @"Revelle", @"Warren", @"Sixth",nil];
    
    departmentArray = [[NSArray alloc]initWithObjects:@"非officer", @"PM", @"学术", @"宣传", @"文体", @"技术",@"外联", @"Advisor&前辈", @"其他officer",nil];
    departmentShow = FALSE;
    collegeShow = FALSE;
    
    collegePicker.delegate = self;
    departmentPicker.delegate = self;
    [departmentPicker setHidden:YES];
    [collegePicker setHidden:YES];
    [bar setHidden:YES];
    
    self.responseData = [NSMutableData data];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    history = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    history.frame = CGRectMake(self.view.frame.size.width*7/10, 440, 70, 70);
    UIImage *btnImage3 = [UIImage imageNamed:@"sayhistory.png"];
    [history setTintColor:[UIColor colorWithRed:161/256.0f  green:135/256.0f  blue:135/256.0f  alpha:1]];
    
    [history setImage:btnImage3 forState:UIControlStateNormal];
    [history addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:history];
}

-(void)history:(UIButton *)sender{
    NSLog(@"show history list");
    [self performSegueWithIdentifier:@"ChatHistorySegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ChatHistoryTableViewController *controller = segue.destinationViewController;
}


-(void)viewWillAppear:(BOOL)animated {
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rkey"] == nil)
        self.view = loginView;      //show loginview
    else
    {
        self.view = profileView;
    nameField.enabled = NO;
    majorField.enabled = NO;
    mottoField.enabled = NO;
    departmentButton.enabled = NO;
    collegeButton.enabled = NO;
    editOrNot = YES;
    [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    }
    
    NSString* rkey = [[NSUserDefaults standardUserDefaults] stringForKey:@"rkey"];
    NSLog(@"rkey %@", rkey);
    [self loadDataWithRKey:rkey];
    arr = [[NSArray alloc]initWithObjects:@"",@"ERC", @"Marshall", @"Muir", @"Revelle", @"Warren", @"Sixth",nil];
    departmentArray = [[NSArray alloc]initWithObjects:@"非officer", @"PM", @"学术部", @"宣传部", @"文体部", @"技术部",@"外联部", @"Advisor&前辈", @"其他officer",nil];

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
                [[NSUserDefaults standardUserDefaults] synchronize];
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
            positionField.backgroundColor = [UIColor clearColor];
            collegeField.backgroundColor = [UIColor clearColor];
            majorField.backgroundColor = [UIColor clearColor];
            mottoField.backgroundColor = [UIColor clearColor];
            if(valueAsString == [NSNull null]){
                continue;
            }
            if ([keyAsString isEqualToString:@"name"]) {
                name = valueAsString;
                [nameField setText:valueAsString];
            }
            
            //NSLog(@"%@", );
            if ([keyAsString isEqualToString:@"department"]) {
                departmentInt = [valueAsString intValue];
                //NSLog(@"%ld!!",(long)departmentInt);
                NSString* de = [departmentArray objectAtIndex:[valueAsString intValue]];
                [positionField setText:de];
            }
            if ([keyAsString isEqualToString:@"college"]) {
                NSString* colle = [arr objectAtIndex:[valueAsString intValue]];
                collegeInt = [valueAsString intValue];
                //NSLog(@"%ld!!!!",(long)collegeInt);
                [collegeField setText:colle];
                
            }
            if ([keyAsString isEqualToString:@"major"]) {
                major = valueAsString;
                [majorField setText:valueAsString];
            }
            if ([keyAsString isEqualToString:@"motto"]) {
                motto = valueAsString;
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



- (IBAction)doneButton:(id)sender {
    
    [collegePicker setHidden:YES];
    [departmentPicker setHidden:YES];
    [bar setHidden:YES];
    collegeShow = false;
    departmentShow = false;
    history.hidden = NO;
}

- (IBAction)chooseCollege:(id)sender {
    collegeShow = true;
    departmentShow = false;
    [self hideAndShow];
    history.hidden = YES;
}

- (IBAction)editProfile:(id)sender
{

    if(editOrNot == YES)
    {
        nameField.enabled = YES;
        majorField.enabled = YES;
        mottoField.enabled = YES;
        departmentButton.enabled = YES;
        collegeButton.enabled = YES;
        [editButton setTitle:@"Save" forState:UIControlStateNormal];
        [editButton setImage:[UIImage imageNamed:@"icon_save.png"] forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nameField becomeFirstResponder];
        editOrNot = NO;
    }
    else
    {
        NSString *collegeString = collegeField.text;
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

        
        NSString *departmentString = positionField.text;
        //NSString *choice = @"请选择";
        NSString *pm = @"PM";
        NSString *xs= @"学术部";
        NSString *xc = @"宣传部";
        NSString *wt = @"文体部";
        NSString *js= @"技术部";
        NSString *wl = @"外联部";
        NSString *ad = @"Advisor&前辈";
        NSString *qt = @"其他officer";
        
        
        
        NSLog(@"@%@",departmentString);
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
        
        name = nameField.text;
        major = majorField.text;
        motto = mottoField.text;
        [TalkToServer updateProfileWithName:name department:departmentNumber position:nil college:collegeNumber major:major motto:motto PerrorString:nil];
        nameField.enabled = NO;
        collegeField.enabled = NO;
        majorField.enabled = NO;
        mottoField.enabled = NO;
        editOrNot = YES;
        [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
        editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [bar setHidden:YES];
        [collegePicker setHidden:YES];
        [departmentPicker setHidden:YES];
        departmentButton.enabled = NO;
        collegeButton.enabled = NO;
    }
     
}

- (IBAction)login:(id)sender {
    NSString * timestampJson = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.convert-unix-time.com/api?timestamp=now"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * timestampDictionary = [NSJSONSerialization JSONObjectWithData:[timestampJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    int i_time = [[timestampDictionary valueForKey:@"timestamp"] intValue];

    int tkey = i_time^1212496151;
    NSString* s_tkey = [NSString stringWithFormat:@"%i",tkey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/login.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"tkey=%@&username=%@&passwd=%@", s_tkey, loging_user.text,[self md5:login_pass.text]];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection setAccessibilityHint:@"login"];

}
- (IBAction)dismissLoginName:(id)sender
{
    [sender resignFirstResponder];
}


- (IBAction)dismissPassword:(id)sender
{
    [sender resignFirstResponder];
}

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


- (IBAction)chooseDepartment:(id)sender {
    departmentShow = true;
    collegeShow = false;
    [self hideAndShow];
    history.hidden = YES;
    
    }

- (IBAction)didBeginEditing:(id)sender {
    
    [self animateTextField: self up: YES];
}

- (IBAction)didEndEditing:(id)sender {
    [self animateTextField: self up: NO];
}

- (IBAction)touchDown:(id)sender {
    [collegePicker setHidden:YES];
    [departmentPicker setHidden:YES];
    [bar setHidden:YES];
    history.hidden = NO;
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


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if([pickerView isEqual: collegePicker]){
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
    
    if([pickerView isEqual: collegePicker]){
        // return the appropriate number of components, for instance
        [collegeField setText:[dataArray objectAtIndex:row]];
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        [positionField setText:[departmentArray objectAtIndex:row]];
    }
    
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([pickerView isEqual: collegePicker]){
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
        [collegePicker setHidden:NO];
        //[bar setHidden:NO];
        [departmentPicker setHidden:YES];
        
    }
    
    if(departmentShow == true && collegeShow == false)
    {
        [departmentPicker setHidden:NO];
        [collegePicker setHidden:YES];
        //[bar setHidden:NO];
        
    }
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    if([pickerView isEqual: collegePicker]){
        // return the appropriate number of components, for instance
        return 1;
    }
    
    if([pickerView isEqual: departmentPicker]){
        // return the appropriate number of components, for instance
        return 1;
    }
    return 1;
    
}

@end
