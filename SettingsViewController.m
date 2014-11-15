//
//  SettingsViewController.m
//  CSSAMon
//
//  Created by zhangjinzhe on 11/8/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsToggleUpdateTableViewCell.h"
#import "SettingsUpdatePeriodTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize SettingsTable = _SettingsTable;

bool isOfficer;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0)
    {
        NSString *simpleTableIdentifier = @"ToggleUpdate";
    
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsToggleUpdate" owner:self options:nil];
            cell = (SettingsToggleUpdateTableViewCell*)[nib objectAtIndex:0];
        }
        [(SettingsToggleUpdateTableViewCell*)cell setLabelText:@"Update my location"];
    }
    else
    {
        NSString *simpleTableIdentifier = @"UpdatePeriod";
        
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsUpdatePeriod" owner:self options:nil];
            cell = (SettingsUpdatePeriodTableViewCell*)[nib objectAtIndex:0];
        }
        
    }
        
    return cell;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    isOfficer = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rkey"] != nil)
    {
        NSString *rkey = [[NSUserDefaults standardUserDefaults] stringForKey:@"rkey"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/isOfficer.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        
        NSString* str = [NSString stringWithFormat:@"rkey=%@", rkey];
        [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLResponse * response;
        
        NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
        isOfficer = [res valueForKey:@"isOfficer"]?YES:NO;
    }
    //[(SettingsUpdatePeriodTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setEnable:isOfficer];
    //[(SettingsToggleUpdateTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setEnable:isOfficer];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}



@end
