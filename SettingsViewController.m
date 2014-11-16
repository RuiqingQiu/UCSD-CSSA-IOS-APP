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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *simpleTableIdentifier;
    
    switch (indexPath.row)
    {
        case 0:
        {
            simpleTableIdentifier = @"SimpleTableItem";
            
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
            simpleTableIdentifier = @"ToggleUpdate";
    
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsToggleUpdate" owner:self options:nil];
                cell = (SettingsToggleUpdateTableViewCell*)[nib objectAtIndex:0];
            }
            cell.textLabel.text=@"Update my location";
            break;
        }
            
        case 2:
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
    [(SettingsUpdatePeriodTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setEnable:isOfficer];
    [(SettingsToggleUpdateTableViewCell*)[_SettingsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] setEnable:isOfficer];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}



@end
