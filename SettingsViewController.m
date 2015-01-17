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
#import "SettingsButtonsTableViewCell.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize SettingsTable = _SettingsTable;

bool isOfficer;
NSTimer* ulutimer;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *simpleTableIdentifier;
    
    switch (indexPath.row)
    {
        case 0:
        {
            simpleTableIdentifier = @"OfficerOptions";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            cell.textLabel.text = @"Officer location update settings";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
            break;
        }
            
        case 1:
        {
            simpleTableIdentifier = @"lastUpdateLocation";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdateLocation"] != nil)
            {
                double time = [[NSDate date] timeIntervalSince1970];
                double lastUpdate = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastUpdateLocation"];
                cell.textLabel.text = [NSString stringWithFormat:@"Last update: %ld seconds ago",(long)(time-lastUpdate)];
            }
            else
                cell.textLabel.text = @"Last update: Never";
            break;
        }
            
        case 2:
        {
            simpleTableIdentifier = @"ToggleUpdate";
    
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsToggleUpdate" owner:self options:nil];
                cell = (SettingsToggleUpdateTableViewCell*)[nib objectAtIndex:0];
            }
            cell.textLabel.text=@"Update my location";
            break;
        }
            
        case 3:
        {
            simpleTableIdentifier = @"UpdatePeriod";
        
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsUpdatePeriod" owner:self options:nil];
                cell = (SettingsUpdatePeriodTableViewCell*)[nib objectAtIndex:0];
            }
            break;
        }
            
        case 4:
        {
            simpleTableIdentifier = @"SettingsButtons";
            
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsButtons" owner:self options:nil];
                cell = (SettingsButtonsTableViewCell*)[nib objectAtIndex:0];
            }
            break;
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
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/isOfficer.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        
        NSString* str = [NSString stringWithFormat:@"rkey=%@", rkey];
        [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLResponse * response;
        
        NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
        isOfficer = [res valueForKey:@"isOfficer"]?YES:NO;
    }
    [_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].textLabel.textColor=isOfficer?[UIColor blackColor]:[UIColor grayColor];
    [_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.textColor=isOfficer?[UIColor blackColor]:[UIColor grayColor];
    [(SettingsUpdatePeriodTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] setEnable:isOfficer];
    [(SettingsToggleUpdateTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setEnable:isOfficer];
    [(SettingsButtonsTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] setEnable:isOfficer];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    ulutimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateLastUpdate:) userInfo:nil repeats:YES];
    self.navigationController.navigationBar.hidden = YES;

}

-(void) updateLastUpdate: (NSTimer *) timer
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdateLocation"] != nil)
    {
        double time = [[NSDate date] timeIntervalSince1970];
        double lastUpdate = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastUpdateLocation"];
        if (lastUpdate>0)
            [_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text = [NSString stringWithFormat:@"Last update: %ld seconds ago",(long)(time-lastUpdate)];
        else
            [_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text = @"Removing location data from server";
    }
    else
        [_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].textLabel.text = @"Last update: Never";
    //NSLog(@"Last update updated!");
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [ulutimer invalidate];
}

-(void) viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [ulutimer invalidate];
}



@end
